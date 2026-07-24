#!/usr/bin/env bash
# Deploy all four lab phases from Azure Cloud Shell (Bash).
#
# Students: sign in to the Azure portal with the assigned lab user, open
# Cloud Shell (Bash), clone this repo, then run with no arguments:
#   ./scripts/deploy-lab.sh
#
# The lab user is provisioned with a resource group named:
#   <whoami>-mcp201-workshop
# Example: fweb11 -> fweb11-mcp201-workshop
# This script constructs that name and does not create the resource group.
#
# Optional: STUDENT_PUBLIC_IP=<ip> to pin Guacamole NSG source instead of auto-detect.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v az >/dev/null 2>&1; then
  echo "ERROR: Azure CLI not found. Use Azure Cloud Shell: https://shell.azure.com"
  exit 1
fi
if ! command -v terraform >/dev/null 2>&1; then
  echo "ERROR: Terraform not found. Use Azure Cloud Shell (Bash)."
  exit 1
fi

az account show -o none >/dev/null 2>&1 || {
  echo "ERROR: not logged in to Azure. Open Cloud Shell from the portal while signed in as your lab user."
  exit 1
}

# Resource groups are named: <cloud-shell-username>-mcp201-workshop
# Example: whoami=fweb11 -> fweb11-mcp201-workshop
LAB_USER="$(whoami | tr '[:upper:]' '[:lower:]')"
RESOURCE_GROUP="${LAB_USER}-mcp201-workshop"

if ! az group show --name "${RESOURCE_GROUP}" -o none 2>/dev/null; then
  echo "ERROR: resource group '${RESOURCE_GROUP}' was not found (or is not readable)."
  echo "Expected naming pattern: <username>-mcp201-workshop (username from whoami: ${LAB_USER})."
  echo "Confirm you are signed in as your assigned lab user and that provisioning has completed."
  exit 1
fi

RG_LOCATION="$(az group show --name "${RESOURCE_GROUP}" --query location -o tsv)"
MY_IP="${STUDENT_PUBLIC_IP:-$(curl -fsSL https://api.ipify.org)}"
STUDENT_CIDR="${MY_IP}/32"

echo "=== FortiWeb lab deploy ==="
echo "Repo:            ${ROOT}"
echo "Signed-in user:  $(az account show --query user.name -o tsv)"
echo "Cloud Shell user: ${LAB_USER}"
echo "Resource group:  ${RESOURCE_GROUP}"
echo "RG location:     ${RG_LOCATION}"
echo "Student NSG IP:  ${STUDENT_CIDR}"
echo

sed_inplace() {
  if [[ "$(uname)" == "Darwin" ]]; then
    sed -i '' "$@"
  else
    sed -i "$@"
  fi
}

for phase in 00-foundation 01-appliances 02-lab-vms 03-routes; do
  tfvars="${ROOT}/${phase}/terraform.tfvars"
  [[ -f "${tfvars}" ]] || continue
  sed_inplace "s|resource_group_name = \".*\"|resource_group_name = \"${RESOURCE_GROUP}\"|" "${tfvars}"
  echo "Updated ${tfvars} -> resource_group_name = \"${RESOURCE_GROUP}\""
done

FOUNDATION_TFVARS="${ROOT}/00-foundation/terraform.tfvars"
sed_inplace "s|student_source_cidr = \".*\"|student_source_cidr = \"${STUDENT_CIDR}\"|" "${FOUNDATION_TFVARS}"
echo "Updated ${FOUNDATION_TFVARS} -> student_source_cidr = \"${STUDENT_CIDR}\""

APPLIANCES_TFVARS="${ROOT}/01-appliances/terraform.tfvars"
if [[ -f "${APPLIANCES_TFVARS}" ]] && grep -q '^location' "${APPLIANCES_TFVARS}"; then
  sed_inplace "s|location *= *\".*\"|location            = \"${RG_LOCATION}\"|" "${APPLIANCES_TFVARS}"
  echo "Updated ${APPLIANCES_TFVARS} -> location = \"${RG_LOCATION}\""
fi
echo

for phase in 00-foundation 01-appliances 02-lab-vms 03-routes; do
  echo "========== ${phase} =========="
  cd "${ROOT}/${phase}"
  terraform init -input=false
  terraform apply
  echo
done

cd "${ROOT}/03-routes"
echo "========== DONE =========="
terraform output guacamole_access
echo
echo "Resource group:  ${RESOURCE_GROUP}"
echo "Open in browser: http://$(terraform output -raw guacamole_access)"
echo "FortiGate/FortiWeb GUI: lab-student / Fortinetlab1!"
