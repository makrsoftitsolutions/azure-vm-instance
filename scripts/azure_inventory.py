#!/usr/bin/env python3
"""Export an Azure subscription resource inventory using Azure CLI."""

import argparse
import csv
import json
import subprocess
from collections import Counter
from pathlib import Path


RESOURCE_QUERY = """
Resources
| project id, name, type, resourceGroup, location,
    provisioningState = tostring(properties.provisioningState),
    resourceState = tostring(properties.state)
| order by type asc, name asc
"""

HEALTH_QUERY = """
HealthResources
| where type =~ 'microsoft.resourcehealth/availabilitystatuses'
| project id, name,
    availabilityState = tostring(properties.availabilityState),
    reason = tostring(properties.reasonType)
"""


def run_json(command):
    result = subprocess.run(command, check=True, capture_output=True, text=True)
    return json.loads(result.stdout)


def query_resource_graph(subscription_id, query):
    results = []
    skip_token = None
    seen_tokens = set()

    while True:
        command = [
            "az",
            "graph",
            "query",
            "--subscriptions",
            subscription_id,
            "--first",
            "1000",
            "--graph-query",
            query,
            "--output",
            "json",
        ]
        if skip_token:
            if skip_token in seen_tokens:
                raise RuntimeError("Azure Resource Graph returned a repeated continuation token.")
            seen_tokens.add(skip_token)
            command.extend(["--skip-token", skip_token])

        page = run_json(command)
        results.extend(page.get("data", []))
        skip_token = page.get("skip_token") or page.get("skipToken")
        if not skip_token:
            return results


def normalized_id(resource_id):
    return resource_id.rstrip("/").lower()


def health_resource_id(health_id):
    marker = "/providers/microsoft.resourcehealth/availabilitystatuses/"
    lower_id = health_id.lower()
    marker_index = lower_id.find(marker)
    if marker_index < 0:
        return ""
    return lower_id[:marker_index]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--subscription", required=True, help="Azure subscription ID")
    parser.add_argument("--output-dir", default="inventory", help="Directory for generated inventory files")
    args = parser.parse_args()

    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    resources = query_resource_graph(args.subscription, RESOURCE_QUERY)
    health_records = query_resource_graph(args.subscription, HEALTH_QUERY)

    vm_records = run_json(
        [
            "az",
            "vm",
            "list",
            "--show-details",
            "--subscription",
            args.subscription,
            "--output",
            "json",
        ]
    )
    vm_power_states = {
        normalized_id(vm["id"]): vm.get("powerState", "")
        for vm in vm_records
        if vm.get("id")
    }

    health_by_resource = {}
    for health in health_records:
        resource_id = health_resource_id(health.get("id", ""))
        if resource_id:
            health_by_resource[resource_id] = {
                "availability_state": health.get("availabilityState") or "Not reported",
                "health_reason": health.get("reason", ""),
            }

    inventory = []
    for resource in resources:
        resource_id = resource.get("id", "")
        runtime_status = vm_power_states.get(normalized_id(resource_id), "")
        if not runtime_status:
            runtime_status = resource.get("resourceState") or "Not reported"

        health = health_by_resource.get(normalized_id(resource_id), {})
        inventory.append(
            {
                "name": resource.get("name", ""),
                "type": resource.get("type", ""),
                "resource_group": resource.get("resourceGroup", ""),
                "location": resource.get("location", ""),
                "provisioning_state": resource.get("provisioningState", "") or "Not reported",
                "runtime_state": runtime_status,
                "availability_state": health.get("availability_state", "Not reported"),
                "health_reason": health.get("health_reason", ""),
                "resource_id": resource_id,
            }
        )

    json_path = output_dir / "resources.json"
    csv_path = output_dir / "resources.csv"
    summary_path = output_dir / "summary.md"

    json_path.write_text(json.dumps(inventory, indent=2) + "\n", encoding="utf-8")
    fieldnames = [
        "name",
        "type",
        "resource_group",
        "location",
        "provisioning_state",
        "runtime_state",
        "availability_state",
        "health_reason",
        "resource_id",
    ]
    with csv_path.open("w", newline="", encoding="utf-8") as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(inventory)

    runtime_counts = Counter(item["runtime_state"] for item in inventory)
    availability_counts = Counter(item["availability_state"] for item in inventory)
    lines = [
        "# Azure Resource Inventory",
        "",
        f"- Subscription: `{args.subscription}`",
        f"- Resources: {len(inventory)}",
        f"- VMs with power-state details: {len(vm_power_states)}",
        f"- Resources with Resource Health records: "
        f"{sum(1 for item in inventory if item['availability_state'] != 'Not reported')}",
        "",
        "## Runtime state",
        "",
        "| State | Count |",
        "|---|---:|",
    ]
    lines.extend(f"| {state} | {count} |" for state, count in sorted(runtime_counts.items()))
    lines.extend(["", "## Availability state", "", "| State | Count |", "|---|---:|"])
    lines.extend(f"| {state} | {count} |" for state, count in sorted(availability_counts.items()))
    lines.append("")
    summary_path.write_text("\n".join(lines), encoding="utf-8")

    print(f"Exported {len(inventory)} resources to {csv_path} and {json_path}.")
    print(summary_path.read_text(encoding="utf-8"))


if __name__ == "__main__":
    main()
