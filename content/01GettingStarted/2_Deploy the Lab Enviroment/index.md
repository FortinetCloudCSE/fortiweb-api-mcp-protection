---
title: "Deploy the Lab Environment"
linkTitle: "Deploy the Lab Environment"
weight: 2
---

## Deploy the Lab Environment

Use **Azure Cloud Shell** from your browser to deploy a personal copy of the lab. Each student uses a dedicated resource group:

`rg-fortiweblab-student-<your-id>`

Follow the full step-by-step guide: **[Student Deploy Guide](STUDENT-DEPLOY.md)**

### Quick summary

1. Open [Azure Cloud Shell](https://shell.azure.com) (Bash).
2. Clone `fortiweb-lab-terraform` into `~/clouddrive`.
3. Run `./scripts/deploy-lab.sh <your-id>`.
4. Open `http://<guacamole_access>` in your browser (output at end of deploy).
