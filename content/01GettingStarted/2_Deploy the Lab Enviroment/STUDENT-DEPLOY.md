---
title: "Student Deploy Guide"
linkTitle: "Student Deploy Guide"
weight: 1
---

## Overview

Step-by-step screenshots for Azure sign-in, Cloud Shell setup, clone, and deploy live in **[The Lab Environment](../1_Lab%20Enviroment/)**.

Use that page as the primary guide. Summary:

1. Sign in to the Azure portal with the credentials from your provisioning email.
2. Open Cloud Shell → **Bash**.
3. Mount storage against your unique student resource group.
4. Clone and run:

```bash
git clone https://github.com/FortinetCloudCSE/fortiweb-api-mcp-protection.git
cd fortiweb-api-mcp-protection/fortiweb-lab-terraform/scripts
chmod +x deploy-lab.sh
./deploy-lab.sh
```

The script discovers your single assigned resource group automatically. No Terraform variable edits are required.
