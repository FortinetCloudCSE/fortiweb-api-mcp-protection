---
title: "Exercise 7.1 – Configure Bot Detection"
linkTitle: "7.1 Configure Detection"
weight: 10
---

## Exercise 7.1 – Configure Bot Detection

### Objective

Configure biometric and threshold-based detection for the Juice Shop application.

### Part A – Biometrics-Based Detection

Navigate to:

**Bot Mitigation → Biometrics Based Detection**

Create a rule with these settings:

| Setting | Value |
|---------|-------|
| Name | `Juice shop` |
| Mouse Movement | Enabled |
| Click | Enabled |
| Keyboard | Enabled |
| Event Collection Period | 15 seconds |
| Report Waiting Time | 10 seconds |
| Bot Effective Time | 5 minutes |
| Action | Alert |
| Severity | Low |

Leave unspecified settings at their defaults and save the rule.

![Biometrics-Based Detection settings — add screenshot](bot-biometrics-settings.png)

Biometric detection uses client-side interaction signals to help distinguish human browsing from automated tools.

### Part B – Threshold-Based Detection

Navigate to:

**Bot Mitigation → Threshold Based Detection**

Create a policy named `juiceshop` and configure:

| Detection | Settings |
|-----------|----------|
| Crawler Detection | Enabled; 10 occurrences within 10 seconds; Alert & Deny |
| Vulnerability Scanning Detection | Enabled; 10 occurrences within 10 seconds; Alert & Deny |
| Slow Attack Detection | Enabled; transaction timeout 60; packet interval timeout 10; 5 occurrences within 100 seconds; Alert |
| Content Scraping Detection | Enabled; 100 occurrences within 30 seconds; Alert |
| Illegal URL Scan | Enabled; Request URL `*` |

![Threshold-Based Detection settings — add screenshot](bot-threshold-settings.png)

{{% notice note %}}
These low thresholds are intended to produce observable events in a classroom environment. Production values must be based on normal application traffic and capacity.
{{% /notice %}}

### Verification Checklist

* Created the `Juice shop` biometric rule
* Created the `juiceshop` threshold policy
* Confirmed that deny actions apply only to crawler and vulnerability-scanning detections in this exercise

### Next Exercise

In Exercise 7.2, you configure known-bot and ML-based detection, combine the controls into a Bot Mitigation Policy, and apply them to Juice Shop.
