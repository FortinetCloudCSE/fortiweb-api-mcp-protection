# CLAUDE.md — fortiweb-api-mcp-protection

> Global preferences (planning workflow, code quality, operations): `~/.claude/CLAUDE.md`
> On-demand: [plans/claude/reference.md](plans/claude/reference.md) — read when you need the key file map (content structure, Terraform phase dirs, workflow files)
> On-demand: [plans/claude/gotchas.md](plans/claude/gotchas.md) — read before touching Terraform phases/tfvars/passwords, lab IPs, `docs/`, or `.github/workflows/`; has the full incident/rationale detail behind every rule below

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

File map (content dirs, Terraform phases, workflows): `plans/claude/reference.md`.

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

## Critical Rules

Full rationale, incident dates, and exact values for every line here: `plans/claude/gotchas.md`.

- **The lab admin password is intentionally tracked and public** (same 13-char value across all four Terraform phase dirs' `terraform.tfvars`, and printed in 4 content pages + the lab README). Don't treat it as a leak or "rotate" it ad hoc — editing all 7 places still leaves it public. **Never add any non-lab secret to these tfvars/bootstrap files** — they are effectively published. A real fix is per-deploy randomization (`random_password` or a required `TF_VAR_admin_password` with no default), not rotation.
- **Terraform phase order is load-bearing**: apply `00-foundation → 01-appliances → 02-lab-vms → 03-routes`, never parallel or out of order (`03-routes` needs `01-appliances`'s appliances to exist). `deploy-lab.sh` does this; `fortiweb-lab-terraform/README.md` is authoritative.
- **Don't add resource-group creation** — the student RG (`<cloud-shell-username>-mcp201-workshop`) is created outside this project; every phase just reads it.
- **Hardcoded lab IPs (10.10.x.x) are part of the contract** — changing any address means updating the bootstrap templates, the route tables, *and* every content page that tells students what to type (6+ pages).
- **Verify FortiGate bootstrap with `diag debug cloudinit show`** on the FortiGate CLI after deploy — it's provisioned via Azure `custom_data` from `configs/fortigate-bootstrap.conf.tpl`.
- **Only Guacamole has an inbound public IP** (NSG `Allow-Guacamole-HTTP8080`, open to the internet for the workshop duration) — don't add inbound rules for the other VMs without deliberate reason.
- **FortiWeb is pinned to PAYG `8.0.5`; FortiGate uses `latest`.** Run `scripts/find_marketplace_images.sh` before changing any marketplace image reference — SKUs churn and Azure marketplace terms must be accepted per plan.
- **`02-lab-vms` images come from a shared gallery in a different subscription/RG** — the lab breaks if that gallery loses read access; don't assume image IDs are portable.
- **No `hugo.toml`/`config.toml` in this repo — on purpose.** Site chrome (title, author, banner, shortcuts) lives in `scripts/repoConfig.json`, not Hugo config.
- **Never put anything in `docs/`.** It's `.gitignore`d here AND `CentralRepo/scripts/batch_repo_update.py` hard-deletes it from `main` on every batch run.
- **Plan/log/spec files go in root-level `plans/`, never `docs/plans/`** — `plans/` is inert to Hugo and outside the machine-deleted folder list. See `plans/README.md`.
- **`.github/workflows/static.yml` is template-managed** — `batch_repo_update.py` overwrites it from CentralRepo; hand-edits get lost on the next run.
- **`downloads/fwb_system_no_defaults.conf` must be merged to `main`** (not just a branch) before the lab step that `curl`s it from `raw.githubusercontent.com` works — Hugo itself doesn't publish `downloads/`.
- **Quote every path** — content directory names contain spaces (e.g. `02Application Delivery Fundamentals`).
- **Grep existing content before inventing a new shortcode** — all shortcodes in use come from the CentralRepo theme, none are defined locally.
- **Page ordering is `weight` in front matter, not filename.**
- **Deploy triggers only on push to `main`** (+ manual `workflow_dispatch`) — branch pushes don't deploy.
- **`codex-advisory-review.yml` uses `pull_request_target` deliberately** (so `OPENAI_API_KEY` comes from the trusted base branch) — do not convert it to `pull_request`.
- **`Jenkinsfile` does not lint content** — its content-check stage is disabled; it only does `deleteDir()` + a commit-status update.
- **Ignore `migration_log*.csv`** — stale artifacts, not even about this repo (paths point elsewhere).
- **`fdevsec.yaml`'s `id.app` is still a placeholder** (`id.org` is real) — don't assume the FortiDevSec scan config is fully wired.

## Environment Variables

None required for authoring. Terraform needs an authenticated Azure CLI session (`az login`; `deploy-lab.sh` is written for Azure Cloud Shell) plus the per-phase `terraform.tfvars` values. CI secrets: `LW_ACCOUNT_NAME`, `LW_API_KEY`, `LW_API_SECRET`, `OPENAI_API_KEY`, `GITHUB_TOKEN` (Pages).

Optional locally: `DOCKER_CONTEXT` / `DOCKER_HOST` — fortihugorunner honors the active Docker context.

## Common Tasks

**Add a workshop module**: create `content/NNTitle/_index.md` with `title`, `linkTitle`, `weight`; add a `content/00ChangeLog/_index.md` entry — this repo maintains one.

**Change site chrome**: edit `scripts/repoConfig.json`.

**Plan/log/spec files**: write them to root-level `plans/` as `NNNN_YYYY-MM-DD_<git-username>_<slug>.md` (+ optional `.log.md`, `.spec.md`). Never `docs/plans/`. `NNNN` is a per-repo sequence; the log is optional; on completion, durable facts get promoted into this file and the plan is left to decay. See `plans/README.md`.

**Change the lab topology**: edit the relevant `fortiweb-lab-terraform/0N-*/` phase, update `fortiweb-lab-terraform/README.md`, and update every content page that references the changed IP/port/credential.

**Debug a broken published page**: run the CI build command locally. `errorLevel` is `warning`, so Hugo warnings do not fail the build.
