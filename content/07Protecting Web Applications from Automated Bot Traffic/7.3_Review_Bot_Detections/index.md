---
title: "Exercise 7.3 – Review Bot Detections"
linkTitle: "7.3 Bot Detections"
weight: 30
---

## Exercise 7.3 – Review Bot Detections

### Objective

Using the Traffic and Attack Log events from Exercise 7.2, compare legitimate browsing with bot traffic and identify which Bot Mitigation engines produced each finding.

### Step 1 – Compare Legitimate and Automated Traffic

Reopen:

* **Log&Report → Log Access → Traffic** — browsing baseline from option **6**
* **Log&Report → Log Access → Attack** — bot detections from option **13**

Contrast:

| Observation | Legitimate browsing | Bot traffic |
|-------------|---------------------|-------------|
| Typical return / action | Success (`200`) in Traffic Log | `Alert_Deny` in Attack Log |
| Main detection types | Usually none (or Informative only) | Known Bots Detection; Threshold Based Detection |
| Example indicators | Normal Juice Shop paths | `/?bot=true`, User-Agents such as `masscan/1.3` |

### Step 2 – Map Events to Detection Engines

For several Attack Log entries, note:

* **Known Bots Detection** — User-Agent / FortiGuard classification (Scanner, Crawler, Scrapers)
* **Threshold Based Detection** — rate or pattern violations (for example, Content Scraping)
* Policy name (`juiceshop-DVWA`), host (`juiceshop.fortiweblab.local`), and action

{{% notice note %}}
Biometrics and ML-Based Bot Detection may produce fewer events in a short lab run. Known Bots and Threshold findings are the primary expected results for the bot-traffic scenario.
{{% /notice %}}

### Step 3 – Confirm Policy Coverage

Recall the `juiceshop` Bot Mitigation Policy from Exercise 7.1:

* Biometrics Based Detection → `juiceshop`
* Threshold Based Detection → `juiceshop`
* Known Bots → `juiceshop`

Explain how at least one Attack Log message ties back to one of those components.

### Reflection Questions

1. Which detection method generated the most events in your run?
2. Which controls denied traffic (`Alert_Deny`), and did any only alert?
3. Did any legitimate browsing request appear in the Attack Log?
4. What threshold would you tune first if false positives occurred?
5. Why should known-good bot bypass rules be narrowly scoped?

### Chapter Summary

You configured biometric, threshold, and known-bot controls; applied them through a Bot Mitigation Policy and Juice Shop Web Protection Profile; generated normal and automated traffic; and reviewed Traffic and Attack Logs. Layered Bot Mitigation improves coverage against both known malicious automation and abusive request patterns.
