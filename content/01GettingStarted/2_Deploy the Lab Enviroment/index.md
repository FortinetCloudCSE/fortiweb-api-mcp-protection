---
title: "Deploy the Lab Environment"
linkTitle: "Deploy the Lab Environment"
weight: 2
---

## Deploy the Lab Environment

Detailed steps and screenshots for signing in, opening Azure Cloud Shell, cloning the repository, and running the initialization script are in **[The Lab Environment](../1_Lab%20Enviroment/)**.

### Quick summary

1. Sign in to [https://portal.azure.com](https://portal.azure.com) with the credentials from your provisioning email.
2. Open **Cloud Shell** and select **Bash**.
3. Mount storage using your unique student resource group.
4. Clone and deploy:

```bash
git clone https://github.com/FortinetCloudCSE/fortiweb-api-mcp-protection.git
cd fortiweb-api-mcp-protection/fortiweb-lab-terraform/scripts
chmod +x deploy-lab.sh
./deploy-lab.sh
```

5. When deploy completes, note `guacamole_access`, then continue to **[Access the Lab Environment](../3_Access%20the%20Lab%20Enviroment/)**.

{{% notice note %}}
`./deploy-lab.sh` takes no arguments. It constructs your resource group as `<whoami>-mcp201-workshop` (for example `fweb11-mcp201-workshop`).
{{% /notice %}}
