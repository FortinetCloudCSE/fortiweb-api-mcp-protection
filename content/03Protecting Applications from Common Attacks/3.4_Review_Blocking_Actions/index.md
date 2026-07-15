---
title: "Exercise 3.4 – Review Blocking Actions"
linkTitle: "3.4 Blocking Actions"
weight: 40
---

## Exercise 3.4 – Review FortiWeb Attack Logs and Blocking Actions

### Objective

In this exercise, you review the FortiWeb Attack Log after the DVWA mapped attack campaign from Exercise 3.3.

You identify different attack types detected by the Web Protection Profile, examine log details, and compare this protected behavior with the unprotected baseline from Exercise 3.1.

---

### Step 1 – Open the FortiWeb Attack Logs

1. Log in to the FortiWeb administrative interface.
2. Navigate to:

   **Log & Report → Log Access → Attack**

The Attack Log displays the malicious requests detected by FortiWeb.

If the results do not appear immediately, click the **Refresh** icon.

![FortiWeb Attack Log overview after DVWA campaign — add screenshot](attack-log-overview.png)

---

### Step 2 – Review Detected SQL Injection Attacks

Locate entries where the following values are displayed:

| Log Field | Expected Value |
|-----------|----------------|
| Main Type | Signature Detection |
| Sub Type | SQL Injection |
| HTTP Host | `dvwa.fortiweblab.local` |

Review the **URL** column. The request should reference a DVWA SQL Injection endpoint, such as:

* `/vulnerabilities/sqli/`
* `/vulnerabilities/sqli_blind/`

![Attack Log filtered or highlighting SQL Injection — add screenshot](attack-log-sqli.png)

#### Observe

FortiWeb identifies the malicious request as SQL Injection because the payload matches one or more configured attack signatures.

Depending on the action configured in the signature policy, FortiWeb may alert, deny, or block the request.

---

### Step 3 – Review Detected Cross-Site Scripting Attacks

Use the log filter to display Cross-Site Scripting events:

1. Click **Add Filter**.
2. Select **Sub Type**.
3. Search for and select **Cross Site Scripting**.

The filtered results should display entries similar to the following:

| Log Field | Expected Value |
|-----------|----------------|
| Main Type | Signature Detection |
| Sub Type | Cross Site Scripting |
| HTTP Host | `dvwa.fortiweblab.local` |

The URL may reference a DVWA XSS endpoint such as:

* `/vulnerabilities/xss_r/`

![Attack Log filtered for Cross Site Scripting — add screenshot](attack-log-xss.png)

#### Observe

The URL or request parameter may contain encoded HTML or JavaScript elements such as `<script>`, `<img>`, or `<svg>`.

FortiWeb decodes and analyzes the request before comparing it against the configured attack signatures.

---

### Step 4 – Review Other Detected Attacks

Clear or modify the existing filter and review the remaining log entries.

Depending on the attack payloads included in the traffic generator and the enabled FortiWeb signatures, you may see categories such as:

* SQL Injection
* Cross-Site Scripting
* OS Command Injection
* Remote File Inclusion
* Local File Inclusion
* Directory Traversal
* Server-Side Injection
* Protocol violations
* Content-encoding evasion

![Attack Log showing multiple attack subtypes — add screenshot](attack-log-multiple-types.png)

{{% notice tip %}}
Not every category is guaranteed to appear. Detection depends on the attack payload, the DVWA endpoint, the enabled signature set, and the actions configured in the Web Protection Profile.
{{% /notice %}}

---

### Step 5 – Open an Individual Attack Log

Select one of the attack log entries to view its details.

Review the available information, including:

* Date and time
* Server policy
* Source IP address
* Destination IP address
* Threat level
* Main attack type
* Attack subtype
* HTTP host
* Requested URL
* Matched signature
* FortiWeb action
* HTTP method
* Request parameters

![Individual attack log detail view — add screenshot](attack-log-detail.png)

#### Consider

Why does the Attack Log provide more useful information than simply observing a blocked page in the browser?

The log identifies **what** happened, **when** it happened, **where** the request originated, **which** application was targeted, and **why** FortiWeb classified the request as malicious.

---

### Step 6 – Compare Source IP Addresses

Review the **Source** column in the Attack Log.

You may notice that the traffic generator uses different simulated source IP addresses. These addresses help create a more realistic attack campaign and allow you to observe how FortiWeb records traffic that appears to come from multiple locations.

The displayed country flag is based on the geolocation associated with the simulated source IP address.

![Attack Log source IPs and geolocation flags — add screenshot](attack-log-source-ips.png)

{{% notice note %}}
These are simulated client addresses supplied by the lab traffic generator. They do not indicate that real external systems are attacking the lab.
{{% /notice %}}

---

### Verification Checklist

Confirm that you completed the following:

* Opened the FortiWeb Attack Log
* Located SQL Injection events
* Filtered for Cross-Site Scripting events
* Reviewed at least one detailed attack log entry
* Confirmed that the target host was `dvwa.fortiweblab.local`

---

### Reflection Questions

1. Which attack types did FortiWeb detect?
2. What value appeared in the **Main Type** field for SQL Injection and Cross-Site Scripting attacks?
3. Which DVWA URL paths appeared most frequently in the logs?
4. Were the attacks only logged, or were they blocked?
5. Which log field identifies the Web Protection mechanism responsible for detecting the request?
6. Why is mapping attacks to the correct DVWA vulnerability page more effective than sending every payload to the same URL?
7. How does this protected behavior differ from the baseline results in Exercise 3.1?

---

### Exercise Summary

In this chapter, you:

1. Manually demonstrated common vulnerabilities against unprotected DVWA
2. Created and applied a dedicated Web Protection Profile
3. Generated a mapped multi-attack campaign with the FortiWeb Lab Traffic Launcher
4. Used the Attack Log to identify:

   * The targeted application
   * The attack category and subtype
   * The affected URL
   * The apparent source address
   * The FortiWeb policy that processed the request
   * The action FortiWeb took

This flow demonstrates both the protection FortiWeb provides and the visibility it gives security administrators during an attack campaign.
