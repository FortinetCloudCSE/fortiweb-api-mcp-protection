#!/usr/bin/env bash
# Deploy all four lab phases from Azure Cloud Shell (Bash).
#
# Students: sign in to the Azure portal with the assigned lab user, open
# Cloud Shell (Bash), clone this repo, then run with no arguments:
#   ./scripts/deploy-lab.sh
#
# The lab user is provisioned with access to exactly one resource group.
# This script discovers that group automatically and does not create it.
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

az account show -o none >/dev/null || {
  echo "ERROR: not logged in to Azure. Open Cloud Shell from the portal while signed in as your lab user."
  exit 1
}

mapfile -t GROUPS < <(az group list --query "[].name" -o tsv)
GROUP_COUNT="${#GROUPS[@]}"

if [[ "${GROUP_COUNT}" -eq 0 ]]; then
  echo "ERROR: no resource groups are visible to this account."
  echo "Sign in with your assigned lab user (it should have access to exactly one resource group)."
  exit 1
fi

if [[ "${GROUP_COUNT}" -ne 1 ]]; then
  echo "ERROR: expected exactly one resource group for this lab user, found ${GROUP_COUNT}:"
  printf '  %s\n' "${GROUPS[@]}"
  echo "Sign in with your assigned lab user, which has access to only its own resource group."
  exit 1
fi

RESOURCE_GROUP="${GROUPS[0]}"
RG_LOCATION="$(az group show --name "${RESOURCE_GROUP}" --query location -o tsv)"
MY_IP="${STUDENT_PUBLIC_IP:-$(curl -fsSL https://api.ipify.org)}"
STUDENT_CIDR="${MY_IP}/32"

echo "=== FortiWeb lab deploy ==="
echo "Repo:            ${ROOT}"
echo "Signed-in user:  $(az account show --query user.name -o tsv)"
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
