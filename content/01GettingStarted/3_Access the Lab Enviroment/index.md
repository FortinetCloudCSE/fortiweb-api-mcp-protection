---
title: "Access the Lab Environment"
linkTitle: "Access the Lab Environment"
weight: 10
---

## Access the Lab Environment

After deployment completes, use Apache Guacamole to access the lab’s Linux desktop. From this desktop, you can open FortiWeb, FortiGate, the training applications, and the traffic-generation tools.

### Before You Begin

Locate the public IP address provided at the end of the deployment process in the previous section. You will use that address to reach Guacamole.

### Step 1 – Open the Guacamole Login Page

From your local desktop, open a web browser and enter:

```text
http://<provided-ip-address>:8080/guacamole/#/
```

Replace `<provided-ip-address>` with the public IP address from the deployment output.

![Apache Guacamole login page](guacamole-login.png)

{{% notice note %}}
Guacamole uses HTTP in this isolated lab. Your browser may label the connection **Not Secure**. Do not reuse these lab credentials outside the training environment.
{{% /notice %}}

### Step 2 – Sign In to Guacamole

Enter the following credentials:

| Field | Value |
|-------|-------|
| Username | `guacadmin` |
| Password | `Fortinet1!` |

Click **Login**.

![Guacamole credentials entered on the login page](guacamole-credentials.png)

### Step 3 – Open the Client Connection

After you sign in, the Guacamole home page displays the available connections.

Click the **Client** connection.

![Guacamole home page showing the Client connection](guacamole-client-connection.png)

Guacamole opens the Linux working desktop in the browser.

![Linux working desktop opened through Guacamole](guacamole-desktop.png)

### Step 4 – Open Google Chrome

On the Linux desktop, click the blue **Internet** globe icon on the bottom panel to open Google Chrome.

![Internet button used to launch Google Chrome](open-chrome.png)

### Step 5 – Download and Restore the FortiWeb Configuration

From the Guacamole desktop, launch a terminal and download the prepared FortiWeb 8.0.5 configuration:

```bash
mkdir -p ~/Downloads
curl -fL \
  https://raw.githubusercontent.com/FortinetCloudCSE/fortiweb-api-mcp-protection/main/downloads/fwb_system_no_defaults.conf \
  -o ~/Downloads/fwb_system_no_defaults.conf
```

Confirm that the file was downloaded:

```bash
ls -lh ~/Downloads/fwb_system_no_defaults.conf
```

![Guacamole desktop terminal showing the FortiWeb configuration downloaded to the Downloads folder](fortiweb-config-download.png)

From the Guacamole desktop:

1. Open the FortiWeb bookmark or browse to [https://10.10.2.100](https://10.10.2.100).
2. Sign in with `azureuser / Fortinetlab1!`.
3. Go to **System > Maintenance > Backup & Restore**.
4. Select **Restore**, then click **Upload** in the **From File** field.

![FortiWeb Backup and Restore page with Restore selected and the Upload button displayed](fortiweb-backup-restore.png)

5. Browse to the **Downloads** folder and select `fwb_system_no_defaults.conf`.

![File chooser showing fwb_system_no_defaults.conf in the Guacamole Downloads folder](fortiweb-config-file-select.png)

6. Click **Restore** and confirm the operation.

![FortiWeb confirmation that the system settings were uploaded successfully](fortiweb-config-restore-success.png)

FortiWeb applies the configuration and restarts. The browser session will disconnect during the restart. Wait several minutes, then refresh [https://10.10.2.100](https://10.10.2.100).

{{% notice note %}}
The FortiWeb login changes after the configuration is restored. Sign in with username `Fortilab` and password `Fortinetlab1!`. The initial `azureuser` account is used only to upload the configuration.
{{% /notice %}}

{{% notice note %}}
This configuration was prepared specifically for the FortiWeb 8.0.5 training environment. Do not restore it to another FortiWeb deployment or a production appliance.
{{% /notice %}}

### Step 6 – Review the Browser Bookmarks

The applications and administrative interfaces used in the lab are already bookmarked in Chrome. The bookmarks include:

* FortiWeb
* FortiGate
* Swagger UI
* crAPI
* OWASP Juice Shop
* DVWA
* Other lab applications

![Chrome showing the bookmarked lab applications](chrome-bookmarks.png)

Use the bookmarks rather than manually entering each application URL.

### Lab Credentials

| System | Username | Password |
|--------|----------|----------|
| Guacamole | `guacadmin` | `Fortinet1!` |
| FortiGate | `lab-student` | `Fortinetlab1!` |
| FortiWeb | `Fortilab` | `Fortinetlab1!` |

{{% notice tip %}}
FortiGate and FortiWeb use lab certificates. Accept the self-signed certificate warning when prompted.
{{% /notice %}}

### Review the Application Architecture

While connected to the jump host, identify the major components you will work with:

* **FortiWeb** — reverse proxy / WAF protecting lab applications
* **Backend web servers** — Juice Shop and DVWA
* **API servers** — PetStore and related API targets
* **MCP server** — AI / Model Context Protocol service
* **Traffic generation tools** — `fortiweb-lab-traffic` on the Guacamole system

Refer to the topology diagram in [The Lab Environment](../1_Lab%20Enviroment/) as needed.

### Key Takeaways

* Access Guacamole at `http://<provided-ip-address>:8080/guacamole/#/`
* Sign in with the dedicated Guacamole lab credentials
* Open the **Client** connection to reach the Linux desktop
* Use the Internet button to launch Chrome
* Download and restore the FortiWeb 8.0.5 training configuration
* Use the preconfigured bookmarks to access FortiWeb and the lab applications
