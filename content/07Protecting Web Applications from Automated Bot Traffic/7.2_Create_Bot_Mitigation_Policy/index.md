---
title: "Exercise 7.2 – Create and Apply the Bot Mitigation Policy"
linkTitle: "7.2 Apply Bot Policy"
weight: 20
---

## Exercise 7.2 – Create and Apply the Bot Mitigation Policy

### Objective

Configure known-bot and ML-based controls, combine the bot-detection components into a policy, and apply the protection to Juice Shop.

### Part A – Configure Known Bots

Navigate to:

**Bot Mitigation → Known Bots**

Create a policy named `juiceshop`.

Configure:

* **Malicious Bots:** Alert & Deny
* **Known Good Bots:** Bypass

![Known Bots policy for Juice Shop — add screenshot](known-bots-policy.png)

{{% notice warning %}}
Bypass trusted bots only when their identity can be validated and their access is appropriate for the application.
{{% /notice %}}

### Part B – Configure ML-Based Bot Detection

Navigate to:

**Bot Mitigation → ML Based Bot Detection**

Configure the following lab values:

| Section | Setting | Value |
|---------|---------|-------|
| Sampling | Client Identification Method | IP and User-Agent |
| Sampling | Sampling Time per Vector | 5 minutes |
| Sampling | Samples per Client per Hour | 3 |
| Sampling | Sample Count | 30 |
| Model Building | Model Type | Moderate |
| Anomaly Detection | Anomaly Count | 1 |
| Anomaly Detection | Bot Confirmation | Enabled |
| Anomaly Detection | Verification Method | Real Browser Enforcement |
| Anomaly Detection | Validation Timeout | 20 seconds |
| Anomaly Detection | Dynamically Update Model | Enabled |
| Action | Action | Alert |
| Action | Severity | High |

Leave other settings at their defaults and save.

![ML-Based Bot Detection settings — add screenshot](ml-bot-detection-settings.png)

### Part C – Create the Bot Mitigation Policy

Navigate to:

**Bot Mitigation → Bot Mitigation Policy**

Create a policy named `juiceshop` and assign:

| Component | Policy |
|-----------|--------|
| Biometrics-Based Detection | `Juice shop` |
| Threshold-Based Detection | `juiceshop` |
| Known Bots | `juiceshop` |

![Combined Bot Mitigation Policy — add screenshot](bot-mitigation-policy.png)

### Part D – Apply Protection to Juice Shop

1. Navigate to **Policy → Web Protection Profile**.
2. Open the Juice Shop protection profile.
3. In the Bot Mitigation section, select the `juiceshop` Bot Mitigation Policy.
4. Save the profile.
5. Open the Server Policy associated with Juice Shop.
6. In the Machine Learning / Bot Detection settings, add the ML-Based Bot Detection policy.
7. Save the Server Policy.

![Bot Mitigation Policy assigned to Juice Shop profile — add screenshot](bot-policy-profile-assignment.png)

![ML-Based Bot Detection assigned to Juice Shop — add screenshot](ml-bot-server-policy-assignment.png)

### Verification Checklist

* Configured known-good and malicious-bot actions
* Created the ML-Based Bot Detection policy
* Combined biometric, threshold, and known-bot controls
* Applied both Bot Mitigation and ML-Based Bot Detection to Juice Shop

### Next Exercise

In Exercise 7.3, you generate normal browsing traffic followed by automated bot traffic.
