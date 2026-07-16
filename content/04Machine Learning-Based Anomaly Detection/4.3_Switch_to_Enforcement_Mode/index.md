---
title: "Exercise 4.3 – Switch to Enforcement Mode"
linkTitle: "4.3 Enforcement Mode"
weight: 30
---

## Exercise 4.3 – Verify the Behavioral Model and Enable Enforcement Mode

### Objective

Confirm that FortiWeb successfully learned Juice Shop behavior from the legitimate traffic generated in Exercise 4.2, then change Machine Learning from **Learning** mode to **Enforcement** mode.

After Enforcement is enabled, every request is evaluated against the learned behavioral model.

---

### Step 1 – Open the Machine Learning Overview

1. Return to the FortiWeb management interface.
2. Navigate to the **Machine Learning Overview** page (Machine Learning / Anomaly Detection overview for the Juice Shop policy).

![Machine Learning Overview page — add screenshot](ml-overview.png)

---

### Step 2 – Observe the Learning Status

Review the current learning status and confirm that FortiWeb has learned application characteristics such as:

* URLs
* HTTP methods
* Parameters
* Parameter patterns
* Behavioral relationships between URLs and parameters

![Machine Learning learned URLs and parameters — add screenshot](ml-learned-urls-parameters.png)

Depending on the amount of generated traffic and lab load, model creation may require several minutes.

Wait until the learning process reaches the **Running** state before continuing.

| Lifecycle stage | What it means |
|-----------------|---------------|
| Collecting | FortiWeb is still gathering legitimate samples |
| Building | Mathematical models are being created |
| Running | Models are ready for anomaly evaluation |
| Discarded | Some parameters could not be modeled reliably |

![Machine Learning status showing Running — add screenshot](ml-status-running.png)

{{% notice tip %}}
If the status remains in Collecting or Building, allow additional time or ask your instructor whether another Standard ML Training run is needed.
{{% /notice %}}

---

### Step 3 – Review Sample Learned Domain Objects (Optional)

If the Overview allows drill-down, open a small sample of learned objects and note:

* URL paths that appear frequently
* Parameters associated with those URLs
* Whether any parameters appear in the **Discarded** state

This is useful context when you later review why an anomalous request was detected.

![Machine Learning domain / parameter detail — add screenshot](ml-domain-detail.png)

---

### Step 4 – Change the Operating Mode to Enforcement

1. Return to the Juice Shop Machine Learning / policy settings used in Exercise 4.1.
2. Change the operating mode from **Learning** to **Enforcement**.

| Setting | Value |
|---------|-------|
| Machine Learning-Based Anomaly Detection | Enabled |
| Operating mode | Enforcement |

![Switch Machine Learning operating mode to Enforcement — add screenshot](ml-enable-enforcement.png)

3. Save the policy.

---

### Step 5 – Verify Enforcement Is Active

Confirm that:

* Machine Learning remains **Enabled**
* The operating mode shows **Enforcement**
* The Machine Learning Overview still shows the Juice Shop model in the **Running** state

![Verified Enforcement Mode configuration — add screenshot](ml-enforcement-verified.png)

From this point forward, requests to Juice Shop are evaluated against the learned behavioral model. Anomalous requests can be classified and actioned according to the Machine Learning policy.

---

### What You Have Accomplished

* Verified that FortiWeb built a behavioral model from legitimate Juice Shop traffic
* Confirmed the model reached the **Running** state
* Switched Machine Learning from Learning to **Enforcement**

### Next Exercise

In Exercise 4.4, you generate an attack campaign against Juice Shop and review Machine Learning detections in the FortiWeb Attack Log.
