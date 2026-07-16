---
title: "Exercise 8.1 – Understand FortiWeb Logs"
linkTitle: "8.1 Understand Logs"
weight: 10
---

## Exercise 8.1 – Understand FortiWeb Logs

### Objective

Become familiar with FortiWeb’s major log categories using events generated throughout the previous chapters.

### Part A – Attack Logs

Navigate to:

**Log & Report → Log Access → Attack**

Review several events and identify:

* Source and destination
* Host and requested URL
* Attack category or matched protection
* Action taken
* Timestamp
* Server policy or protection profile

Find examples from earlier exercises, such as SQL Injection, XSS, API violations, MCP violations, or bot activity.

![Attack Log with several security event types — add screenshot](operations-attack-log.png)

### Part B – Traffic Logs

Navigate to:

**Log & Report → Log Access → Traffic**

Use these logs to verify that requests reached FortiWeb, determine the HTTP response, and correlate normal transactions with attack events.

![Traffic Log showing application requests — add screenshot](operations-traffic-log.png)

### Part C – Event Logs

Open the Event Log and look for administrator logins, configuration changes, policy updates, signature updates, or system notifications.

![Event Log showing administrative activity — add screenshot](operations-event-log.png)

### Part D – System Logs

Review available system or appliance-health logs. These can contain service messages, errors, HA events, and licensing information.

![System Log or appliance events — add screenshot](operations-system-log.png)

### Verification Checklist

* Opened all four log categories
* Located at least one security event from an earlier chapter
* Identified the policy and action responsible for an Attack Log entry
* Located a normal request in the Traffic Log

### Next Exercise

In Exercise 8.2, you investigate individual web, API, and MCP events using a consistent workflow.
