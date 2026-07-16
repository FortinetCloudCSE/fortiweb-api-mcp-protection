---
title: "Exercise 4.2 – Generate Legitimate Traffic"
linkTitle: "4.2 Legitimate Traffic"
weight: 20
---

## Exercise 4.2 – Generate Legitimate Application Traffic

### Objective

Machine Learning requires representative samples of legitimate application traffic before it can build an accurate behavioral model.

Instead of manually browsing Juice Shop for an extended period, you use the **FortiWeb Lab Traffic Launcher** to simulate realistic user activity and accelerate model creation for the classroom.

{{% notice note %}}
The traffic generator is part of a controlled training environment. Do not run these tests against systems outside the lab.
{{% /notice %}}

---

### Step 1 – Open a Terminal

From the Guacamole desktop, open the terminal application.

The command prompt should display the student account on the Guacamole system.

![Guacamole terminal ready for lab traffic tool — add screenshot](guacamole-terminal.png)

---

### Step 2 – Navigate to the Traffic Generator Directory

At the terminal prompt, enter:

```bash
cd ~/fortiweb-lab-traffic
```

Confirm that the prompt shows:

```text
student@guacamole01:~/fortiweb-lab-traffic$
```

---

### Step 3 – Launch the FortiWeb Lab Traffic Tool

Run:

```bash
./fortiweb-lab-traffic
```

The FortiWeb Lab Traffic Launcher menu appears:

```text
================================
  FortiWeb Lab Traffic Launcher
================================

1. Web application traffic generator
2. API traffic generator
3. MCP traffic generator
4. Run complete FortiWeb training scenario
5. Run all attack campaigns concurrently
6. Exit
```

![FortiWeb Lab Traffic Launcher main menu — add screenshot](traffic-launcher-main-menu.png)

---

### Step 4 – Select the Web Application Traffic Generator

At the `Select option:` prompt, enter:

```text
1
```

This opens the Web Application Traffic Generator menu.

Confirm that the target references Juice Shop:

```text
Target: https://juiceshop.fortiweblab.local/
```

![Web Application Traffic Generator menu with Juice Shop target — add screenshot](web-app-traffic-generator-menu.png)

{{% notice tip %}}
If the target does not show Juice Shop, use the menu option to select the Lab Application Profile / hostname for Juice Shop before generating ML training traffic.
{{% /notice %}}

---

### Step 5 – Run Standard ML Training

From the Web Application Traffic Generator menu, enter:

```text
8
```

Option **8** is:

```text
Standard ML Training (2000 requests)
```

The Standard ML Training option generates approximately **2,000** legitimate HTTP requests using multiple unique parameter values. The generated traffic simulates realistic Juice Shop user behavior, including:

* Browsing products
* Viewing product details
* Searching
* Navigating categories
* Shopping cart operations
* Typical user workflows

![Standard ML Training running against Juice Shop — add screenshot](ml-training-running.png)

Allow the traffic generator to complete before proceeding.

{{% notice warning %}}
Do not close the terminal while the script is running.
{{% /notice %}}

---

### Step 6 – Confirm Campaign Completion

When training finishes, review the terminal output for a completion message or request summary.

![Standard ML Training completed — add screenshot](ml-training-complete.png)

Optional lab variants (if available in your menu and approved by your instructor):

| Option | Description |
|--------|-------------|
| `7` | Quick ML Training (500 requests) — faster, less diverse |
| `8` | Standard ML Training (2000 requests) — recommended |
| `9` | Extended ML Training (10000 requests) — more complete model |

For this lab, use **option 8** unless your instructor directs otherwise.

---

### Verification Checklist

Confirm that you completed the following:

* Navigated to `~/fortiweb-lab-traffic`
* Launched `./fortiweb-lab-traffic`
* Selected option **1** – Web application traffic generator
* Confirmed the Juice Shop target
* Selected option **8** – Standard ML Training
* Allowed the campaign to finish successfully

---

### Next Exercise

In Exercise 4.3, you return to FortiWeb, verify that the behavioral model has reached the **Running** state, and switch Machine Learning from Learning mode to **Enforcement** mode.
