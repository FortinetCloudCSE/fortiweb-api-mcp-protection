---
title: "Exercise 7.3 – Generate Legitimate and Bot Traffic"
linkTitle: "7.3 Generate Bot Traffic"
weight: 30
---

## Exercise 7.3 – Generate Legitimate and Bot Traffic

### Objective

Generate a normal browsing baseline, then run an automated bot scenario against Juice Shop.

{{% notice warning %}}
Use the supplied generator only in the controlled lab environment.
{{% /notice %}}

### Step 1 – Launch the Traffic Tool

From the Guacamole terminal, run:

```bash
cd ~/fortiweb-lab-traffic
./fortiweb-lab-traffic
```

Select:

```text
1 – Web application traffic generator
```

Choose the Juice Shop application profile and confirm the displayed target.

![Web traffic generator targeting Juice Shop — add screenshot](juice-shop-traffic-generator.png)

### Step 2 – Generate Legitimate Browsing Traffic

Select:

```text
6 – Realistic Browsing Traffic
```

Allow the scenario to run for several minutes. This traffic simulates normal navigation and provides a baseline for comparison.

![Realistic browsing traffic in progress — add screenshot](legitimate-browsing-traffic.png)

### Step 3 – Generate Bot Traffic

Return to the Web Application Traffic Generator and confirm the Juice Shop target. Select:

```text
13 – Bot Traffic
```

The scenario produces high-speed requests, crawler behavior, repetitive access patterns, and scanner-like activity intended to exercise Bot Mitigation.

![Bot Traffic scenario in progress — add screenshot](bot-traffic-running.png)

Allow the scenario to complete.

### Step 4 – Note the Behavioral Differences

Compare the terminal output for both scenarios:

* Request timing and rate
* Repetition of URLs
* Navigation patterns
* Client or source variation

### Verification Checklist

* Generated realistic browsing traffic for Juice Shop
* Generated the Bot Traffic scenario
* Allowed both scenarios to complete

### Next Exercise

In Exercise 7.4, you review Bot Mitigation events and determine which detection engine handled each request.
