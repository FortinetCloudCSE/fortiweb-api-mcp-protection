#!/usr/bin/env bash
# Deploy all four lab phases from Azure Cloud Shell (Bash).
#
# Usage:
#   ./scripts/deploy-lab.sh <student-id>              # auto-detect public IP
#   ./scripts/deploy-lab.sh <student-id> <public-ip>  # fixed IP for NSG
#
# Examples:
#   ./scripts/deploy-lab.sh jsmith
#   ./scripts/deploy-lab.sh wtefera 203.0.113.10
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

usage() {
  echo "Usage: $0 <student-id> [public-ip]"
  echo "  student-id   Short unique id (letters/numbers). RG: rg-fortiweblab-student-<student-id>"
  echo "  public-ip    Optional. Guacamole NSG source. Default: auto-detect via api.ipify.org"
  exit 1
}

[[ $# -lt 1 ]] && usage

STUDENT_ID="$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9-')"
[[ -z "$STUDENT_ID" ]] && { echo "ERROR: invalid student-id"; usage; }

RESOURCE_GROUP="rg-fortiweblab-student-${STUDENT_ID}"
MY_IP="${2:-$(curl -fsSL https://api.ipify.org)}"
STUDENT_CIDR="${MY_IP}/32"

echo "=== FortiWeb lab deploy ==="
echo "Repo:            $ROOT"
echo "Student ID:      $STUDENT_ID"
echo "Resource group:  $RESOURCE_GROUP"
echo "Student NSG IP:  $STUDENT_CIDR"
echo

if ! command -v az >/dev/null 2>&1; then
  echo "ERROR: Azure CLI not found. Use Azure Cloud Shell: https://shell.azure.com"
  exit 1
fi
if ! command -v terraform >/dev/null 2>&1; then
  echo "ERROR: Terraform not found. Use Azure Cloud Shell (Bash)."
  exit 1
fi

az account show -o table >/dev/null || { echo "Run: az login"; exit 1; }

sed_inplace() {
  if [[ "$(uname)" == "Darwin" ]]; then
    sed -i '' "$@"
  else
    sed -i "$@"
  fi
}

for phase in 00-foundation 01-appliances 02-lab-vms 03-routes; do
  tfvars="$ROOT/$phase/terraform.tfvars"
  [[ -f "$tfvars" ]] || continue
  sed_inplace "s|resource_group_name = \".*\"|resource_group_name = \"${RESOURCE_GROUP}\"|" "$tfvars"
  echo "Updated $tfvars -> resource_group_name = \"${RESOURCE_GROUP}\""
done

FOUNDATION_TFVARS="$ROOT/00-foundation/terraform.tfvars"
sed_inplace "s|student_source_cidr = \".*\"|student_source_cidr = \"${STUDENT_CIDR}\"|" "$FOUNDATION_TFVARS"
echo "Updated $FOUNDATION_TFVARS -> student_source_cidr = \"${STUDENT_CIDR}\""
echo

for phase in 00-foundation 01-appliances 02-lab-vms 03-routes; do
  echo "========== $phase =========="
  cd "$ROOT/$phase"
  terraform init -input=false
  terraform apply
  echo
done

cd "$ROOT/03-routes"
echo "========== DONE =========="
terraform output guacamole_access
echo
echo "Resource group:  $RESOURCE_GROUP"
echo "Open in browser: http://$(terraform output -raw guacamole_access)"
echo "FortiGate/FortiWeb GUI: lab-student / Fortinetlab1!"
