# Reference — fortiweb-api-mcp-protection

> Key file map. Read this when you need to know where something lives; the repo `CLAUDE.md` only
> keeps a one-line stack summary and imperative rules.

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
