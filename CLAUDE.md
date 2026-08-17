# CLAUDE.md — fortiweb-api-mcp-protection

> Global preferences (planning workflow, code quality, operations): `~/.claude/CLAUDE.md`

## Project in One Line

A FortinetCloudCSE hands-on workshop — "Protecting Modern Applications, APIs, and MCP Services with FortiWeb" — published as a Hugo static site to GitHub Pages, backed by a four-phase Terraform build that deploys FortiGate + FortiWeb + Guacamole + two Docker hosts into a pre-created Azure resource group.

## Stack Quick Reference

| Layer | Tech | Port |
|-------|------|------|
| Site generator | Hugo via `public.ecr.aws/k4n6m5h8/fortinet-hugo:latest` | 1313 (local dev) |
| Site theme/config | [CentralRepo](https://github.com/FortinetCloudCSE/CentralRepo) — mounted at build time, **not** in this repo | — |
| Local dev driver | [fortihugorunner](https://github.com/FortinetCloudCSE/fortihugorunner) CLI | — |
| Hosting | GitHub Pages (`https://fortinetcloudcse.github.io/fortiweb-api-mcp-protection/`) | — |
| Lab infra | Terraform `>= 1.8.0`, `azurerm ~> 4.0` (all four phases); `02-lab-vms` also uses `Azure/azapi` | — |
| Lab access | Apache Guacamole at `10.10.3.200`, the only inbound public IP | 8080 |
| Lab appliances | FortiGate PAYG (`fortinet_fortigate-vm`, version `latest`), FortiWeb PAYG `8.0.5` | — |

## Key File Map

```
content/                    — workshop pages (Hugo page bundles, ordered by `weight`)
  00ChangeLog/              — "What's New" page; repo maintains a version list
  01GettingStarted/
  02Application Delivery Fundamentals/
  03Protecting Applications from Common Attacks/
  04Machine Learning-Based Anomaly Detection/
  05API Security/  06MCP Protection/
  07Protecting Web Applications from Automated Bot Traffic/
  08Operations Logging and Troubleshooting/  09Lab Summary and Wrap-Up/
layouts/shortcodes/         — repo-local shortcodes: ContainerFlow.html, FTNThugoFlow.html, fortihugorunner.html
static/videos/              — contains only `.gitkeep` (no media tracked here)
downloads/fwb_system_no_defaults.conf  — FortiWeb config students curl from raw.githubusercontent.com
scripts/repoConfig.json     — per-repo site config (title, author, banner, shortcuts)
fortiweb-lab-terraform/
  00-foundation/            — VNet + subnets (server 10.10.1.0/24, protected 10.10.2.0/24,
                              client 10.10.3.0/24), NSGs, NAT Gateway + outbound public IP,
                              Guacamole public IP
  01-appliances/            — FortiGate + FortiWeb marketplace VMs, NICs, VIP secondary IPs
  02-lab-vms/               — Guacamole, Docker1, Docker2 from shared-gallery captured images
  03-routes/                — route tables + subnet associations (applied LAST)
  each phase dir            — main.tf, variables.tf, outputs.tf, providers.tf, terraform.tfvars (tracked!)
  configs/fortigate-bootstrap.conf.tpl, fortiweb-bootstrap.conf.tpl
  scripts/deploy-lab.sh, find_marketplace_images.sh
  README.md                 — authoritative lab topology, IPs, phase ordering, student instructions
plans/                      — plan/log/spec files, `NNNN_` prefixed (see gotchas); plans/README.md explains why
Jenkinsfile                 — GitHub commit-status pipeline; its content-check stage is disabled
fdevsec.yaml                — FortiDevSec scan config
.github/workflows/
  static.yml                     — build + deploy to Pages; `push` to `main` + `workflow_dispatch`
                                   (inputs: `runner_type`, `image_variant` prod/dev)
  lacework-code-security-pr.yml  — `on: pull_request`
  codex-advisory-review.yml      — `on: pull_request_target` (opened, synchronize, reopened, ready_for_review)
repo_upgrade_spec.json / .repo_upgrade_version  — both say `Hugo-v2.1`
migration_log.csv, migration_log_dry_run.csv    — historical image-migration artifacts
```

No `Dockerfile`, `hugo.toml`, or `config.toml` in this repo, and no `docs/` on disk.

## Build & Run Commands

```bash
# Preview the site locally (requires Docker + fortihugorunner on PATH)
fortihugorunner pull-image --env author-dev
fortihugorunner launch-server \
  --docker-image fortinet-hugo:latest \
  --host-port 1313 --container-port 1313 --watch-dir .
# open http://localhost:1313

# Reproduce the CI static build exactly
docker run --rm -v "$PWD:/home/UserRepo" fortinet-hugo:latest build

# Lab infrastructure — phases MUST run in order (see gotcha)
cd fortiweb-lab-terraform && ./scripts/deploy-lab.sh
```

There is no automated test suite. Content changes are validated by rendering locally; lab changes against real Azure resources.

## Critical Patterns & Gotchas

- **The lab admin password is tracked, public, and shared by every deployment — by design, but it is still a real weakness.** All four phase dirs (`00-foundation`, `01-appliances`, `02-lab-vms`, `03-routes`) track a `terraform.tfvars` on `origin/main` of a repo GitHub reports as **PUBLIC**. `01-appliances` sets `admin_password` + `fortigate_lab_student_password`, `02-lab-vms` sets `admin_password`; all three are the same 13-character value, and `.gitignore` does not cover tfvars (`git check-ignore` exits 1).

  **This is not an accidental leak.** The same value is printed in four workshop content pages (`01GettingStarted/3_Access the Lab Enviroment/`, `02Application Delivery Fundamentals/1_Load_Balancing/`, `03Protecting Applications from Common Attacks/3.4_Review_Blocking_Actions/`, `04Machine Learning-Based Anomaly Detection/4.1_Configure_Machine_Learning/`) plus `fortiweb-lab-terraform/README.md` and `scripts/deploy-lab.sh` — students are told to type it in. It has been in the tree since the initial Terraform commit (`6223738`, 2026-06-16). "Rotating" it means editing all seven places, and it would still be public.

  **The actual risk is that it is static and shared:** every lab instance anywhere gets the same appliance admin password, and `00-foundation`'s NSG rule `Allow-Guacamole-HTTP8080` has `source_address_prefix = "*"`, so the entry point is internet-reachable. The fix is per-deploy randomization (`random_password` → `terraform output`, or a required `TF_VAR_admin_password` with no default), not a one-time rotation. **Do not add any non-lab secret to these files** — they are effectively published.
- **Terraform phase order is load-bearing, not stylistic.** `03-routes` must be applied *after* `01-appliances` — routing through FortiGate/FortiWeb before the appliances exist breaks the deploy. `scripts/deploy-lab.sh` iterates `00-foundation 01-appliances 02-lab-vms 03-routes` and finishes in `03-routes`; don't apply phases in parallel or out of order. `fortiweb-lab-terraform/README.md` is authoritative.
- **The student resource group is created outside this project.** Every phase reads it via `data "azurerm_resource_group"`. Naming convention is `<cloud-shell-username>-mcp201-workshop` (from `whoami`), enforced by `deploy-lab.sh`. Don't add resource-group creation.
- **Hardcoded lab IPs are part of the contract.** FortiGate `port2` static `10.10.2.101/24` (`port1` is DHCP); FortiWeb protected-side `10.10.2.100`; VIPs `10.10.3.150–153` → mapped `10.10.2.150–153` (`FortiWeb_virt_1` on `extintf port1`, virt 2–4 on `any`); Guacamole `10.10.3.200`; `03-routes` sends `10.10.3.0/24` to next hop `10.10.2.101` so VIP reverse-DNAT restores client replies; FortiWeb's own route sends `10.10.3.0/24` via gateway `10.10.2.101`. Changing any address means updating the bootstrap templates, the route tables, *and* the content pages that tell students what to type (`10.10.` appears in at least six content pages).
- **FortiGate is bootstrapped via Azure `custom_data`** from `configs/fortigate-bootstrap.conf.tpl` — interfaces, the four VIPs, firewall policies, and a `lab-student` `super_admin` with `trusthost1 10.10.3.0/24` whose password is templated from `fortigate_lab_student_password`. Verify with `diag debug cloudinit show` on the FortiGate CLI after deploy.
- **Only Guacamole has an inbound public IP,** via NSG rule `Allow-Guacamole-HTTP8080` (TCP/8080, `source_address_prefix = "*"`, destination `10.10.3.200`) — i.e. open to the internet for the workshop duration. FortiGate, FortiWeb, Docker1, Docker2 have none; outbound is via NAT Gateway with its own public IP (needed for licensing and FortiGuard). `ip_forwarding_enabled = true` on the appliance NICs.
- **FortiWeb is pinned to PAYG `8.0.5`** (`fortiweb_offer = "fortinet_fortiweb-vm_v5"`, `fortiweb_sku = "fortinet_fw-vm_payg_v3"`, set both as the `fortiweb_version` variable default and in `01-appliances/terraform.tfvars`); FortiGate uses `fortigate_version = "latest"`. Marketplace terms must be accepted per plan (see the commented `az vm image terms accept` lines in `01-appliances/main.tf`), and SKUs churn — run `scripts/find_marketplace_images.sh` before changing an image reference.
- **`02-lab-vms` images come from a shared gallery in a different subscription/RG** (captured from `rg_Wondy_Fortiweb_Training` / `fortiweb_lab_gallery`; CUS uses `*-v2` definitions with SCSI + Accelerated Networking because the original CUS Linux-docker-2 image is TrustedLaunch-only). Image IDs are pinned in `02-lab-vms/terraform.tfvars` — the lab breaks if that gallery loses read access.
- **No `hugo.toml` or `config.toml` here — on purpose.** Config/theme come from CentralRepo. Site title, author, banner, and sidebar shortcuts live in **`scripts/repoConfig.json`**; `.gitignore` also excludes `hugo.toml` and `config.toml` so they can't be recreated locally. Live values: `author` `"Wondyrad Tefera"`, `errorLevel` `"warning"`, `marketingCode` `"CloudCSE-Xperts2026"`, `themeVariant` `"CloudCSEMovie"`.
- **`docs/` is doubly machine-owned — never put anything there.** `.gitignore` excludes `docs/`, and `CentralRepo/scripts/batch_repo_update.py` hardcodes `FOLDERS_TO_DELETE = ["docs"]` with `BRANCH = "main"`, deleting every blob under `docs/` via the GitHub tree API and pushing that deletion straight to `main`. Nuance: that script does **not** read `repo_upgrade_spec.json` — the spec file documents the same lists but is not what executes, so the two can silently drift.
- **Plan/log/spec files go in root-level `plans/`, not `docs/plans/`.** `plans/` is inert to Hugo (Hugo only reads `content/`, `layouts/`, `static/`, `assets/`, `data/`, `i18n/`, `archetypes/`, `themes/`) and is outside `FOLDERS_TO_DELETE`. `plans/README.md` in this repo states the convention.
- **`.github/workflows/static.yml` is template-managed.** `batch_repo_update.py` overwrites it from the operator's CentralRepo checkout (`FILES_TO_COPY`) — hand-edits get lost. It also copies in a `Dockerfile` (this repo currently has none) and deletes `layouts/shortcodes/FTNThugoFlow.html`, `docker-compose.yml`, `hugo.toml`, `config.toml`, and the `scripts/docker_*.sh` set. `FTNThugoFlow.html` is present here and unused by content — expect it to disappear on the next batch run.
- **`downloads/` is not published by Hugo.** Hugo reads only `content/`, `layouts/`, `static/`, `assets/`, `data/`, `i18n/`, `archetypes/`, `themes/`. `content/01GettingStarted/3_Access the Lab Enviroment/index.md` has students `curl` the config from `https://raw.githubusercontent.com/FortinetCloudCSE/fortiweb-api-mcp-protection/main/downloads/fwb_system_no_defaults.conf` — so the file must be merged to `main` (not just a branch) before that lab step works, and the repo must stay public.
- **Content directory names contain spaces** (`02Application Delivery Fundamentals`, `3_Access the Lab Enviroment`). Quote paths in every shell command and script.
- **Container mount layout:** the workshop repo mounts at `/home/UserRepo`; CentralRepo lives at `/home/CentralRepo`; Hugo output lands in `/home/CentralRepo/public` (CI copies that to `docs/` and uploads it as the Pages artifact).
- **Shortcodes:** content uses `{{% notice %}}` (77x) plus one each of `{{< notice >}}`, `{{< launchdemoform >}}`, and `{{% badge %}}` — all from the CentralRepo theme, none defined locally. Grep existing content before inventing a new shortcode.
- **Page ordering is `weight` in front matter,** not filename.
- **Deploy triggers on push to `main`** (plus manual `workflow_dispatch`). Branch pushes do not deploy.
- **`fdevsec.yaml` is half-configured:** `id.org` is a real UUID (`2e3b7756-…`), but `id.app` is still the literal placeholder `<insert app id here>`. Scanners enabled: `sast`, `secret`, `sca`, `iac`, `container`; `resource.serial_scan: false`; `fail_pipeline.risk_rating: 7`. Note the `secret` scanner is enabled yet the tracked tfvars passwords are still in the tree.
- **`codex-advisory-review.yml` uses `pull_request_target` deliberately** so `OPENAI_API_KEY` comes from the trusted base branch and the PR head is never checked out. Do not convert it to `pull_request`.
- **`Jenkinsfile` does not lint content.** Its "Checking for question/discussion section" stage is gated by `when { expression { false } }`; what actually runs is `deleteDir()` plus a GitHub commit-status update.
- **`migration_log*.csv` are stale artifacts and not even about this repo** — their paths point at `/home/ubuntu/pythonProjects/UserRepo/content/…`. Never treat them as inputs.
- **`package.json` / `package-lock.json` are listed in `.gitignore` but tracked** (they predate the ignore entries). `.gitignore` also references `tools/fortiweb-lab-traffic/fortiweb-lab-traffic`, but no `tools/` directory exists here.

## Environment Variables

None required for authoring. Terraform needs an authenticated Azure CLI session (`az login`; `deploy-lab.sh` is written for Azure Cloud Shell) plus the per-phase `terraform.tfvars` values. CI secrets: `LW_ACCOUNT_NAME`, `LW_API_KEY`, `LW_API_SECRET`, `OPENAI_API_KEY`, `GITHUB_TOKEN` (Pages).

Optional locally: `DOCKER_CONTEXT` / `DOCKER_HOST` — fortihugorunner honors the active Docker context.

## Common Tasks

**Add a workshop module**: create `content/NNTitle/_index.md` with `title`, `linkTitle`, `weight`; add a `content/00ChangeLog/_index.md` entry — this repo maintains one.

**Change site chrome**: edit `scripts/repoConfig.json`.

**Plan/log/spec files**: write them to root-level `plans/` as `NNNN_YYYY-MM-DD_<git-username>_<slug>.md` (+ optional `.log.md`, `.spec.md`). Never `docs/plans/`. `NNNN` is a per-repo sequence; the log is optional; on completion, durable facts get promoted into this file and the plan is left to decay. See `plans/README.md`.

**Change the lab topology**: edit the relevant `fortiweb-lab-terraform/0N-*/` phase, update `fortiweb-lab-terraform/README.md`, and update every content page that references the changed IP/port/credential.

**Debug a broken published page**: run the CI build command locally. `errorLevel` is `warning`, so Hugo warnings do not fail the build.
