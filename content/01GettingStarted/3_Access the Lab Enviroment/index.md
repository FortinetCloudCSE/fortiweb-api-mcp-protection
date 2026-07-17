---
title: "Access the Lab Environment"
linkTitle: "Access the Lab Environment"
weight: 10
---

## Access the Lab Environment

After deployment completes, use Guacamole to reach the lab desktop and the systems you will use throughout the course.

### Step 1 – Log In to Guacamole

1. Open the Guacamole URL printed at the end of deployment:

   ```text
   http://<guacamole_access>
   ```

2. Sign in with the Guacamole credentials provided by your instructor (or configured in the lab gallery image).
3. Connect to the Linux jump-host desktop session.

![Guacamole login or desktop session — add screenshot](guacamole-login.png)

### Step 2 – Review Available Tools and Credentials

From the Guacamole desktop, confirm that you can reach the following systems:

| System | Access from Guacamole | Username | Password |
|--------|------------------------|----------|----------|
| FortiGate | `https://10.10.3.101` | `lab-student` | `Fortinetlab1!` |
| FortiWeb | `https://10.10.2.100` | `Fortilab` | `Fortinetlab1!` |
| Lab applications | Browser shortcuts / bookmarks | Varies by application | See later exercises |
| Traffic generator | Terminal → `~/fortiweb-lab-traffic` | Student account | N/A |

{{% notice tip %}}
Accept any self-signed certificate warnings for FortiGate and FortiWeb in the lab environment.
{{% /notice %}}

![Browser bookmarks and terminal on Guacamole desktop — add screenshot](guacamole-desktop-tools.png)

### Step 3 – Review the Application Architecture

While connected to the jump host, identify the major components you will work with:

* **FortiWeb** — reverse proxy / WAF protecting lab applications
* **Backend web servers** — Juice Shop and DVWA
* **API servers** — PetStore and related API targets
* **MCP server** — AI / Model Context Protocol service
* **Traffic generation tools** — `fortiweb-lab-traffic` on the Guacamole system

Refer to the topology diagram in [The Lab Environment](../1_Lab%20Enviroment/) as needed.

### Key Takeaways

* Access the lab through Guacamole after deployment
* Use the jump host to reach FortiGate, FortiWeb, applications, and tools
* Confirm the major components before starting the security exercises
