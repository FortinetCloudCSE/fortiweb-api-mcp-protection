---
title: "Exercise 8.2 – Investigate Security Events"
linkTitle: "8.2 Investigate Events"
weight: 20
---

## Exercise 8.2 – Investigate Security Events

### Objective

Determine what FortiWeb detected, which control made the decision, and whether the request reached the backend.

### Step 1 – Investigate a DVWA Attack

In the Attack Log, locate a SQL Injection event generated during Chapter 3.

Review:

* Source and destination
* Requested URL and HTTP method
* Server policy
* Attack signature or detection reason
* Protection action
* Timestamp

![Detailed DVWA SQL Injection event — add screenshot](investigate-dvwa-sqli.png)

Answer:

1. Which protection detected the attack?
2. What action did FortiWeb take?
3. Would the request have reached the backend?
4. Do nearby events indicate a larger campaign?

### Step 2 – Investigate an API Event

Locate a PetStore API event from Chapter 5. Identify the endpoint, method, parameter or schema violation, and action.

![Detailed PetStore API security event — add screenshot](investigate-api-event.png)

### Step 3 – Investigate an MCP Event

Locate an MCP event from Chapter 6. Determine whether it was caused by a signature, prompt protection, or JSON schema validation.

![Detailed MCP security event — add screenshot](investigate-mcp-event.png)

### Step 4 – Correlate With Traffic Logs

Search the Traffic Log using the event time, source, host, and URL. Correlation can reveal the requests before and after a detection and help reconstruct the activity.

![Correlated Traffic and Attack Log entries — add screenshot](correlated-log-events.png)

{{% notice tip %}}
Record timestamps and time zones carefully. Small timing differences can make correlation difficult across FortiWeb, application, and external logging systems.
{{% /notice %}}

### Verification Checklist

* Investigated one web attack
* Investigated one API event
* Investigated one MCP event
* Correlated at least one event with Traffic Logs

### Next Exercise

In Exercise 8.3, you use the evidence from an event to choose the smallest safe policy adjustment.
