# FortiWeb Azure Training Lab Terraform

This Terraform is organized in phases so routing is not applied before FortiGate/FortiWeb are alive.

## Phases

1. `00-foundation` - resource group, VNet, subnets, NSGs, Guacamole public IP
2. `01-appliances` - FortiGate PAYG and FortiWeb PAYG marketplace VMs
3. `02-lab-vms` - Guacamole, Docker1, Docker2 from captured images
4. `03-routes` - route tables and subnet associations

## Important

- Only Guacamole gets a public IP.
- FortiGate, FortiWeb, Docker1, and Docker2 do not get public IPs.
- FortiGate and FortiWeb NICs have IP forwarding enabled.
- Students update the Guacamole NSG source IP to their own public IP.
- FortiWeb has an extra data disk. Default is 30 GB; 
- FortiGate is bootstrapped at first boot via `configs/fortigate-bootstrap.conf.tpl` (interfaces, VIPs, 5 firewall policies, `lab-student` admin).

## FortiGate bootstrap

Phase `01-appliances` passes `configs/fortigate-bootstrap.conf.tpl` as Azure `custom_data`. On first boot FortiOS applies:

| Item | Setting |
|------|---------|
| `port1` (outside) | DHCP — Azure assigns `10.10.3.101` |
| `port2` (inside) | Static `10.10.2.101/24` |
| VIPs | `10.10.3.150–153` → `10.10.2.150–153` |
| Policies 1–4 | Client → FortiWeb VIP DNAT |
| Policy 5 | Client → FortiWeb mgmt `10.10.2.100` (SNAT) |
| Admin `lab-student` | `super_admin`, trusted hosts `10.10.3.0/24` |

Set `fortigate_lab_student_password` in `01-appliances/terraform.tfvars`. Students log in at `https://10.10.3.101` from Guacamole.

Verify after deploy: `diag debug cloudinit show` on the FortiGate CLI.

Edit `configs/fortigate-bootstrap.conf.tpl` to change lab networking; changing `custom_data` replaces the FortiGate VM on next apply.

## FortiWeb bootstrap

Phase `01-appliances` also passes `configs/fortiweb-bootstrap.conf.tpl` to FortiWeb `custom_data`. On first boot it applies:

| Item | Setting |
|------|---------|
| `port1` (protected) | DHCP — Azure assigns `10.10.2.100` |
| `port2` (server) | Static `10.10.1.100/24` |
| VIPs / vservers | `virt-1`–`virt-4` on `10.10.2.150–153` |
| Server pools | MCP, DVWA, JUICESHOP, crAPI, petstore → docker hosts |
| Static routes | Default via `10.10.2.1`; client `10.10.3.0/24` via FortiGate `10.10.2.101` |
| Admin `lab-student` | `prof_admin`, trusted hosts `10.10.3.0/24`, same password as FortiGate |

Students log in at `https://10.10.2.100` from Guacamole. 

## Before applying

Edit each phase `terraform.tfvars` and set:

- `location`
- `admin_username`
- `admin_password`
- FortiGate/FortiWeb marketplace image values if different in your region
- Custom image IDs for Guacamole/Docker images
- `student_source_cidr`

Run `scripts/find_marketplace_images.sh` to confirm exact publisher/offer/sku/version values in your subscription/region.

## Apply order

```bash
cd 00-foundation
terraform init
terraform apply

cd ../01-appliances
terraform init
terraform apply

cd ../02-lab-vms
terraform init
terraform apply

cd ../03-routes
terraform init
terraform apply
```

After the final `terraform apply` in `03-routes`, note the output:

```text
guacamole_access = "20.1.2.3:8080"
```

Open `http://<that-value>` in a browser to reach the Guacamole jump host (ensure `student_source_cidr` in `00-foundation` allows your public IP).

## Student deploy from Azure Cloud Shell 

Students only need a browser and an Azure subscription with **Contributor** access. No local Terraform install.

### 1. Open Cloud Shell

1. Go to [https://portal.azure.com](https://portal.azure.com) and sign in.
2. Click the **Cloud Shell** icon (`>_`) in the top bar.
3. Choose **Bash** (not PowerShell).
4. If prompted, create or attach storage for Cloud Shell (one-time).

Cloud Shell includes `az`, `terraform`, `git`, and `curl`.

### 2. Get the Terraform repo

**Option A — clone from GitHub** 

```bash
cd ~/clouddrive
git clone https://github.com/<org>/fortiweb-lab-terraform.git
cd fortiweb-lab-terraform
```



### 3. (Optional) Verify marketplace images

```bash
chmod +x scripts/*.sh
./scripts/find_marketplace_images.sh eastus
```

Both FortiGate and FortiWeb lines must end with **OK**.

### 4. Deploy everything (one script)

Replace `<your-id>` with your assigned student ID (e.g. `jsmith`):

```bash
chmod +x scripts/deploy-lab.sh
./scripts/deploy-lab.sh <your-id>
```

The script sets resource group `rg-fortiweblab-student-<your-id>` in all phases, auto-detects your public IP for `student_source_cidr`, then runs all four applies.

Fixed public IP (VPN):

```bash
./scripts/deploy-lab.sh <your-id> 203.0.113.10
```

**One resource group per student** is required when sharing a subscription.

### 5. Open the lab

When deploy finishes, note the output:

```text
guacamole_access = "20.1.2.3:8080"
```

Open **`http://20.1.2.3:8080`** in your laptop browser.

| Login | Value |
|-------|--------|
| Guacamole | (credentials baked into gallery image) |
| FortiGate / FortiWeb GUI | `lab-student` / `Fortinetlab1!` |



### Student laptop requirements

| Need | Required? |
|------|-----------|
| Terraform / Azure CLI installed locally | No |
| Browser | Yes |
| Azure subscription + Contributor role | Yes |
| Fortinet marketplace access (PAYG) | Yes (accepted automatically by Terraform) |

Allow **25-30 minutes** for the full deploy. Work from `~/clouddrive` so files persist between Cloud Shell sessions.
