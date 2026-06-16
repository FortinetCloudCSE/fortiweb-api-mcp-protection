#!/usr/bin/env bash
set -euo pipefail
LOCATION="${1:-eastus}"

FG_PUBLISHER="${FG_PUBLISHER:-fortinet}"
FG_OFFER="${FG_OFFER:-fortinet_fortigate-vm_v5}"
FG_SKU="${FG_SKU:-fortinet_fg-vm_payg_20190624}"

FW_PUBLISHER="${FW_PUBLISHER:-fortinet}"
FW_OFFER="${FW_OFFER:-fortinet_fortiweb-vm_v2}"
FW_SKU="${FW_SKU:-fortinet_fw-vm_payg}"

echo "Location: $LOCATION"
echo "Terraform defaults (01-appliances/variables.tf):"
echo "  FortiGate: $FG_PUBLISHER / $FG_OFFER / $FG_SKU / latest"
echo "  FortiWeb:  $FW_PUBLISHER / $FW_OFFER / $FW_SKU / latest"
echo

echo "Fortinet publishers:"
az vm image list-publishers -l "$LOCATION" --query "[?contains(name, 'fortinet')].name" -o table

echo
echo "FortiGate offers:"
az vm image list-offers -l "$LOCATION" -p fortinet --query "[?contains(name, 'fortigate') || contains(name, 'FortiGate')].name" -o table || true

echo
echo "FortiGate SKUs for offer $FG_OFFER:"
az vm image list-skus -l "$LOCATION" -p fortinet -f "$FG_OFFER" -o table || true

echo
echo "FortiWeb offers:"
az vm image list-offers -l "$LOCATION" -p fortinet --query "[?contains(name, 'fortiweb') || contains(name, 'FortiWeb')].name" -o table || true

echo
echo "FortiWeb SKUs for offer $FW_OFFER:"
az vm image list-skus -l "$LOCATION" -p fortinet -f "$FW_OFFER" -o table || true

echo
echo "Verify Terraform FortiGate image (must succeed for deploy):"
if az vm image show -l "$LOCATION" -p "$FG_PUBLISHER" -f "$FG_OFFER" -s "$FG_SKU" --version latest -o table; then
  echo "OK: FortiGate SKU is available in $LOCATION"
else
  echo "FAIL: FortiGate SKU not found — update 01-appliances/variables.tf or terraform.tfvars"
  exit 1
fi

echo
echo "Verify Terraform FortiWeb image (must succeed for deploy):"
if az vm image show -l "$LOCATION" -p "$FW_PUBLISHER" -f "$FW_OFFER" -s "$FW_SKU" --version latest -o table; then
  echo "OK: FortiWeb SKU is available in $LOCATION"
else
  echo "FAIL: FortiWeb SKU not found — update 01-appliances/variables.tf or terraform.tfvars"
  exit 1
fi

echo
echo "Newer FortiGate marketplace (Fortinet 2026 templates — optional migration):"
echo "  offer: fortinet_fortigate-vm"
echo "  sku:   fortinet_fg-vm_payg_76"
az vm image show -l "$LOCATION" -p fortinet -f fortinet_fortigate-vm -s fortinet_fg-vm_payg_76 --version latest -o table 2>/dev/null || \
  echo "  (not listed in $LOCATION — legacy SKU above may still be required)"
