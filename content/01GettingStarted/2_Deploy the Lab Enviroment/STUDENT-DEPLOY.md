---
title: "Student Deploy Guide"
linkTitle: "Student Deploy Guide"
weight: 1
---

## Overview

Deploy your personal lab from **Azure Cloud Shell** in a browser. You do not need Terraform or the Azure CLI on your laptop.

Each student gets a **dedicated Azure resource group** so labs do not conflict when many people share one subscription.

| Item | Value |
|------|--------|
| Resource group | `rg-fortiweblab-student-<your-id>` |
| Example | `rg-fortiweblab-student-jsmith` |
| Region | `eastus` (default in Terraform) |
| Lab access URL | `http://<public-ip>:8080` (printed at end of deploy) |

## Do I need my own resource group?

**Yes**, when students share one Azure subscription (typical for a class).

| Scenario | Resource group |
|----------|----------------|
| Shared class subscription | **One RG per student** — `rg-fortiweblab-student-xxx` |
| Solo subscription, one lab | You can still use the student format for consistency |

Pick a short **student ID** (letters/numbers only), e.g. your first initial + last name: `wtefera`, `jsmith`, `student01`.

## Prerequisites

- Azure subscription with **Contributor** access
- A laptop with a web browser only
- Allow **45–90 minutes** for the full deployment

## Step 1 — Open Azure Cloud Shell

1. Sign in to [https://portal.azure.com](https://portal.azure.com).
2. Click the **Cloud Shell** icon (`>_`) in the top toolbar.
3. Select **Bash**.
4. If prompted, create storage for Cloud Shell (one-time).

## Step 2 — Clone the Terraform repo

```bash
cd ~/clouddrive
git clone https://github.com/<instructor-org>/fortiweb-lab-terraform.git
cd fortiweb-lab-terraform
chmod +x scripts/*.sh
```

Your instructor will provide the Git URL. Use `~/clouddrive` so files persist if Cloud Shell restarts.

## Step 3 — (Optional) Verify marketplace images

```bash
./scripts/find_marketplace_images.sh eastus
```

Both FortiGate and FortiWeb checks should end with **OK**.

## Step 4 — Deploy your lab

Replace `<your-id>` with your assigned student ID (lowercase, no spaces):

```bash
./scripts/deploy-lab.sh <your-id>
```

Examples:

```bash
./scripts/deploy-lab.sh jsmith
./scripts/deploy-lab.sh wtefera
```

The script will:

1. Create settings for resource group `rg-fortiweblab-student-<your-id>` in all Terraform phases
2. Detect your public IP and allow Guacamole access on port **8080**
3. Run phases `00-foundation` → `01-appliances` → `02-lab-vms` → `03-routes`
4. Print your Guacamole URL

If you are on a VPN or the auto-detected IP is wrong:

```bash
./scripts/deploy-lab.sh <your-id> 203.0.113.10
```

Approve each `terraform apply` when prompted (`yes`).

## Step 5 — Open the lab

When deployment finishes you will see:

```text
guacamole_access = "20.1.2.3:8080"
```

Open in your browser:

```text
http://20.1.2.3:8080
```

(use the IP from your output)

## Logins (after Guacamole)

| System | URL (from Guacamole) | Username | Password |
|--------|----------------------|----------|----------|
| FortiGate | `https://10.10.3.101` | `lab-student` | `Fortinetlab1!` |
| FortiWeb | `https://10.10.2.100` | `lab-student` | `Fortinetlab1!` |

Guacamole credentials are set in the gallery image your instructor provides.

## Manual deploy (phase by phase)

Only if you prefer not to use the script:

```bash
STUDENT_ID="jsmith"
RG="rg-fortiweblab-student-${STUDENT_ID}"
MY_IP=$(curl -fsSL https://api.ipify.org)

for f in 00-foundation 01-appliances 02-lab-vms 03-routes; do
  sed -i "s|resource_group_name = \".*\"|resource_group_name = \"${RG}\"|" "$f/terraform.tfvars"
done
sed -i "s|student_source_cidr = \".*\"|student_source_cidr = \"${MY_IP}/32\"|" 00-foundation/terraform.tfvars

cd 00-foundation && terraform init && terraform apply
cd ../01-appliances && terraform init && terraform apply
cd ../02-lab-vms && terraform init && terraform apply
cd ../03-routes && terraform init && terraform apply
terraform output guacamole_access
```

## Troubleshooting

| Problem | What to do |
|---------|------------|
| Cannot open Guacamole `:8080` | Re-run deploy script or update `student_source_cidr` with `curl -fsSL https://api.ipify.org` |
| Resource group already exists | Use a different student ID or ask instructor to delete old RG |
| Marketplace image error | Run `./scripts/find_marketplace_images.sh eastus` and contact instructor |
| Deploy interrupted | `cd` to the failed phase folder and run `terraform apply` again |

## Tear down

When the class is done, delete your resource group in the portal or:

```bash
az group delete --name rg-fortiweblab-student-<your-id> --yes --no-wait
```
