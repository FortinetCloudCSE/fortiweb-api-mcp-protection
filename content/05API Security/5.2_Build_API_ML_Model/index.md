---
title: "Exercise 5.2 – Build the API ML Model"
linkTitle: "5.2 Build API ML Model"
weight: 20
---

## Exercise 5.2 – Build the Machine Learning API Model

### Objective

FortiWeb needs sufficient legitimate API traffic before it can accurately distinguish normal requests from malicious ones.

In this exercise, you use the **FortiWeb Lab Traffic Launcher** to generate legitimate PetStore traffic, then verify that FortiWeb has discovered API endpoints and learned schema information.

{{% notice note %}}
The traffic generator and PetStore application are part of a controlled training environment. Do not run these tests against systems outside the lab.
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

### Step 4 – Select the API Traffic Generator

At the `Select option:` prompt, enter:

```text
2
```

This opens the API Traffic Generator menu.

![API Traffic Generator menu — add screenshot](api-traffic-generator-menu.png)

---

### Step 5 – Run PetStore ML Learning Traffic

From the API Traffic Generator menu, enter:

```text
13
```

Option **13** is:

```text
PetStore ML Learning – Legitimate Endpoint Coverage
```

This scenario generates approximately **2,000** legitimate API requests covering major PetStore endpoints using realistic data and normal request patterns.

During this process, FortiWeb can learn:

* API endpoints
* HTTP methods
* Request frequency
* JSON schema structure
* Parameter names and types
* Normal parameter values

![PetStore ML Learning traffic running — add screenshot](petstore-ml-learning-running.png)

Allow the script to complete before proceeding.

{{% notice warning %}}
Do not close the terminal while the script is running.
{{% /notice %}}

![PetStore ML Learning traffic completed — add screenshot](petstore-ml-learning-complete.png)

---

### Step 6 – Verify API Discovery in FortiWeb

1. Log in to the FortiWeb management interface.
2. Navigate to the **API Protection** / API Discovery section for the PetStore security policy (or the PetStore Web Protection Profile, depending on the lab template).

![FortiWeb API Protection / Discovery navigation — add screenshot](fortiweb-api-discovery-nav.png)

3. Review the automatically discovered API inventory.

Observe that FortiWeb has identified items such as:

* Available API endpoints
* Supported HTTP methods
* Parameters
* Learned schema information

![PetStore discovered API inventory — add screenshot](petstore-api-inventory.png)

Notice that FortiWeb can build an inventory of the application’s APIs from observed traffic, without requiring you to manually import an OpenAPI specification in this exercise.

{{% notice tip %}}
If discovery results are sparse, wait a short time and refresh the page, or ask your instructor whether another ML Learning run is needed.
{{% /notice %}}

---

### Verification Checklist

Confirm that you completed the following:

* Launched `./fortiweb-lab-traffic`
* Selected option **2** – API traffic generator
* Selected option **13** – PetStore ML Learning
* Allowed the campaign to complete
* Reviewed discovered PetStore endpoints in FortiWeb

---

### Next Exercise

In Exercise 5.3, you launch mapped API attacks against the same PetStore endpoints so FortiWeb can detect schema violations, abnormal parameter values, and traditional attack payloads delivered through the API.
