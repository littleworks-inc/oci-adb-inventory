#!/bin/bash

# Output CSV file
output_file="autonomous_db_details_$(date +%Y%m%d_%H%M%S).csv"

# CSV Header
echo "Environment,Compartment ID,Container DB ID,Database OCID,DB Name,DB Version,Storage GB,Storage TB,Used Storage GB,Used Storage TB,Compute Model,Lifecycle State,Maintenance Schedule,Upgrade Versions,Backup Config,Backup Retention Days,Compute Count,In Memory GB,In Memory %" > "$output_file"

# Function to process each compartment
process_compartment() {
    local compartment_id=$1
    local environment=$2
    
    echo "Processing $environment environment, compartment: $compartment_id"
    
    # Get ADB details and format as CSV with escaped key names
    oci db autonomous-database list \
        --compartment-id "$compartment_id" \
        --query 'data[*].{
            "compartment": "compartment-id",
            "container_db": "autonomous-container-database-id",
            "id": "id",
            "db_name": "db-name",
            "db_version": "db-version",
            "storage_gb": "data-storage-size-in-gbs",
            "storage_tb": "data-storage-size-in-tbs",
            "used_storage_gb": "used-data-storage-size-in-gbs",
            "compute_model": "compute-model",
            "lifecycle_state": "lifecycle-state",
            "maintenance": "autonomous-maintenance-schedule-type",
            "upgrade_versions": "available-upgrade-versions",
            "backup_config": "backup-config",
            "backup_retention": "backup-retention-period-in-days",
            "compute_count": "compute-count",
            "memory_gb": "in-memory-area-in-gbs",
            "memory_percent": "in-memory-percentage"
        }' \
        --output json | jq -r --arg env "$environment" '.[] | . as $row | 
        # Calculate TB from GB with 3 decimal places
        ($row."used_storage_gb" // 0 | . / 1024 | tostring | if contains(".") then . else . + ".000" end) as $used_tb |
        # Ensure storage_tb has 3 decimal places
        (.storage_tb | tostring | if contains(".") then . else . + ".000" end) as $storage_tb |
        [
            $env,
            .compartment,
            .container_db,
            .id,
            .db_name,
            .db_version,
            .storage_gb,
            $storage_tb,
            .used_storage_gb,
            $used_tb,
            .compute_model,
            .lifecycle_state,
            .maintenance,
            .upgrade_versions,
            .backup_config,
            .backup_retention,
            .compute_count,
            .memory_gb,
            .memory_percent
        ] | @csv' >> "$output_file"
}

# Check if compartments file is provided
if [ "$1" = "-f" ] && [ -n "$2" ]; then
    # Read compartments from file
    while IFS= read -r line || [ -n "$line" ]; do
        if [ ! -z "$line" ]; then
            # Extract compartment_id and environment from the line
            read -r compartment_id environment <<< "$line"
            if [ ! -z "$compartment_id" ] && [ ! -z "$environment" ]; then
                process_compartment "$compartment_id" "$environment"
            fi
        fi
    done < "$2"
else
    # For direct command line arguments, default to "unknown" environment
    for compartment_id in "$@"; do
        echo "Processing compartment: $compartment_id (Environment: unknown)"
        process_compartment "$compartment_id" "unknown"
    done
fi

echo "Output saved to: $output_file"
