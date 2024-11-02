# OCI Autonomous Database Inventory Script

A bash script to generate a comprehensive inventory of Oracle Cloud Infrastructure (OCI) Autonomous Databases across multiple compartments.

## Features

- Lists all Autonomous Databases across specified compartments
- Supports environment tagging (prod/nonprod)
- Generates detailed CSV report including:
  - Environment details
  - Database identification (OCID, Name, Version)
  - Storage metrics (GB and TB with decimal precision)
  - Compute specifications
  - Configuration details
  - Maintenance and backup information

## Prerequisites

- OCI CLI installed and configured
- `jq` command-line JSON processor
- Bash shell environment
- Appropriate OCI permissions to list Autonomous Databases

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/oci-adb-inventory.git
cd oci-adb-inventory
```

2. Make the script executable:
```bash
chmod +x get_adb_details.sh
```

## Usage

### Using Compartments File

1. Create a compartments.txt file with compartment OCIDs and environments:
```
ocid1.compartment.oc1..xxxx nonprod
ocid1.compartment.oc1..yyyy prod
```

2. Run the script:
```bash
./get_adb_details.sh -f compartments.txt
```

### Direct Command Line Usage

```bash
./get_adb_details.sh ocid1.compartment.oc1..xxxx ocid1.compartment.oc1..yyyy
```

## Output

The script generates a CSV file with the following information:
- Environment (prod/nonprod)
- Compartment ID
- Container DB ID
- Database OCID
- DB Name
- DB Version
- Storage GB/TB
- Used Storage GB/TB
- Compute Model
- Lifecycle State
- Maintenance Schedule
- Upgrade Versions
- Backup Config
- Backup Retention Days
- Compute Count
- Memory Details

Output filename format: `autonomous_db_details_YYYYMMDD_HHMMSS.csv`

## Repository Structure

```
oci-adb-inventory/
├── README.md
├── get_adb_details.sh
└── examples/
    └── compartments.txt
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
