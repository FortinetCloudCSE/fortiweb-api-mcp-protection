---
title: "Exercise 8.4 – Troubleshooting Challenge"
linkTitle: "8.4 Troubleshooting Challenge"
weight: 40
---

## Exercise 8.4 – Troubleshooting Challenge

### Objective

Use a structured methodology to investigate an application-access problem without assuming FortiWeb is the cause.

### Scenario

A user reports that a protected application is unavailable or that one workflow fails. Your task is to identify where the request stops and determine the next appropriate action.

### Step 1 – Verify Client and DNS Behavior

From the Guacamole desktop:

* Confirm the requested host name
* Verify DNS resolution
* Confirm the browser reaches the expected virtual server
* Record the approximate time and error or status code

![Browser error or failed application request — add screenshot](troubleshooting-client-symptom.png)

### Step 2 – Verify Traffic Reaches FortiWeb

Review the Traffic Log for the recorded host, source, and time.

If no request appears, investigate client connectivity, DNS, routing, and virtual-server addressing before changing security policies.

![Traffic Log search for failed request — add screenshot](troubleshooting-traffic-log.png)

### Step 3 – Determine Whether FortiWeb Blocked It

Review the Attack Log.

If a matching event exists:

* Identify the triggered protection
* Review the detection reason
* Confirm the configured action
* Decide whether the request is malicious or legitimate

![Attack Log showing possible blocked request — add screenshot](troubleshooting-attack-log.png)

### Step 4 – Verify Backend Health

Confirm:

* The server pool is healthy
* Health checks succeed
* Backend servers are reachable
* The application responds normally

![Server pool and health-check status — add screenshot](troubleshooting-server-pool-health.png)

Application outages are not always caused by the WAF.

### Step 5 – Review Appliance Health

Check CPU, memory, disk utilization, FortiGuard update status, license state, and High Availability status where applicable.

![FortiWeb system health dashboard — add screenshot](troubleshooting-system-health.png)

### Step 6 – Escalate With Evidence

If the issue remains unresolved, collect:

* Relevant Traffic, Attack, Event, and System Logs
* Exact timestamps and time zone
* Source, host, URL, and response code
* Packet captures or diagnostic output when appropriate
* Recent configuration or application changes

Use advanced diagnostics with your instructor, operational runbook, or Fortinet Support.

### Challenge Questions

1. Did the request reach FortiWeb?
2. Did FortiWeb deny it?
3. Was the backend healthy?
4. Was appliance capacity or licensing involved?
5. What evidence supports your root-cause conclusion?

### Chapter Summary

Effective FortiWeb operations depend on continuous monitoring, disciplined investigation, and narrowly scoped tuning. By correlating logs and checking each layer in order, administrators can resolve issues without unnecessarily weakening protection or disrupting legitimate users.
