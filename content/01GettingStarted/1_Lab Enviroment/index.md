---
title: "Task 1 – Environment Deployment and Access"
linkTitle: "The Lab Enviroment"
weight: 1
---
---
title: "1.Quickstart"
weight: 1
---

#### Provisioning the Azure environment (40min)

Provision your Azure Environment, enter your Email address and click _Provision_
{{< launchdemoform labdefinition="fweb-mcp-110" >}}

{{< notice warning >}} After submitting, this page will return with a blank email address box and no other indications.

Provisioning can take several minutes.

\*\*\* __PLEASE DO NOT SUBMIT MULTIPLE TIMES__ \*\*\*  {{< /notice >}}

When provisioning is complete, one of the following will happen.

* You will receive an email with Azure environment credentials. Use those credentials for this environment, even if you have your own.
* You will receive and email indicating that there are no environments available to utilize. In this case please try again at a later date.
* You will receive an email indicating that the supplied email address is from an unsupported domain.
* No email received due to an unexpected error. You can try again or notify the Azure CSE team.

Tasks

* Setup Azure Cloud Shell
* Run Terraform
* Verify Terraform
## Objective

Deploy the training environment and become familiar with the lab topology.

## Lab Architecture

The diagram below summarizes the FortiWeb training lab: Guacamole client access, FortiGate perimeter, FortiWeb WAF, and Docker application targets.

![FortiWeb Training Lab topology — WAF, API Security, MCP Security, FortiGate perimeter, and Docker training targets](lab-image.png)

| Component | Role | Key addresses |
|-----------|------|----------------|
| Guacamole | Student jump host | `10.10.3.200` (+ source IPs `.201`–`.206`) |
| FortiGate-VM01 | Perimeter firewall | Outside `10.10.3.101`, Inside `10.10.2.101` |
| FortiWeb-VM01 | WAF / API / MCP protection | Protected `10.10.2.100`, Server `10.10.1.100` |
| linux-docker-1 | Juice Shop, DVWA, MCP | `10.10.1.200` |
| linux-docker-2 | Petstore, crAPI | `10.10.1.202` |

## Topics Covered

- Lab architecture overview
- Components deployed by Terraform
- Application topology
- FortiWeb deployment mode
- Accessing the environment through Guacamole
