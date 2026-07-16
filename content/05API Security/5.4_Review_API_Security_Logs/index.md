---
title: "Exercise 5.4 – Review API Security Logs"
linkTitle: "5.4 API Security Logs"
weight: 40
---

## Exercise 5.4 – Review API Security Logs

### Objective

After the PetStore mapped attack campaign completes, review FortiWeb logs to identify how API Protection and Machine Learning detected malicious or anomalous API requests.

Compare those events with the learned API inventory from Exercise 5.2.

---

### Step 1 – Open the FortiWeb Attack / API Security Logs

1. Log in to the FortiWeb administrative interface.
2. Navigate to:

   **Log & Report → Log Access → Attack**

   (or the API Security / API Protection log view provided in your lab build)

3. Refresh the view if events do not appear immediately.

![FortiWeb Attack Log after PetStore API attacks — add screenshot](attack-log-api-overview.png)

---

### Step 2 – Filter for PetStore Events

Locate entries related to the PetStore application. Depending on the lab configuration, useful filter fields may include:

* HTTP Host (for example, `petstore.fortiweblab.local`)
* Server policy / Web Protection Profile
* Attack subtype or Main Type
* Requested URL / endpoint

![Attack Log filtered for PetStore host or API events — add screenshot](attack-log-petstore-filter.png)

---

### Step 3 – Review Key Log Fields

For several events, observe:

* Attack type / subtype
* Source IP address
* Requested endpoint (URL)
* HTTP method
* Violated parameter (if shown)
* Severity / threat level
* Action taken (alert, deny, block, and similar)
* Date and time
* Matched signature or Machine Learning / schema reason

![Individual API attack log detail — add screenshot](attack-log-api-detail.png)

---

### Step 4 – Compare Events With the Learned API Model

Return to the API Discovery / API Protection page for PetStore.

Compare the learned API model with the malicious requests that generated alerts. Look for evidence that FortiWeb identified requests that:

* Violate the learned schema
* Contain unexpected parameters
* Include abnormal parameter values
* Deliver traditional web attacks through API endpoints

![API Discovery inventory compared with attack events — add screenshot](api-discovery-vs-attacks.png)

#### Consider

Why is mapping attacks to previously discovered endpoints more useful than sending every payload to a single URL?

Mapped attacks exercise the same paths FortiWeb learned during legitimate traffic, which makes schema violations, unexpected parameters, and abnormal values easier to observe in the logs.

---

### Verification Checklist

Confirm that you completed the following:

* Opened the FortiWeb Attack / API Security logs
* Located PetStore-related events
* Reviewed at least one detailed log entry
* Compared attack events with the discovered API inventory

---

### Reflection Questions

1. Which PetStore endpoints appeared most often in the attack logs?
2. Did FortiWeb detect schema violations, abnormal parameter values, traditional attack payloads, or a combination?
3. Which log fields helped you identify the violated parameter or detection reason?
4. How does ML-based API Protection help when an OpenAPI specification is missing or outdated?
5. How does this chapter’s API-focused detection differ from the web application signature exercises in Chapter 3?

---

### Chapter Summary

In this chapter, you learned that modern applications depend heavily on REST APIs, making API security a critical part of application protection. Unlike traditional web pages, APIs expose business logic and structured data directly to clients, creating challenges such as Broken Object Level Authorization (BOLA), excessive data exposure, schema violations, and API abuse.

You also explored FortiWeb’s API Protection capabilities, including API Discovery, OpenAPI validation concepts, JSON inspection, and Machine Learning–based behavioral analysis. By learning legitimate application behavior, FortiWeb can detect both known attacks and previously unseen anomalies—even without a manually maintained API specification.

Using PetStore, you completed the full workflow: exploring API endpoints, generating legitimate traffic to build a behavioral model, launching mapped API attacks, and reviewing the resulting security events. This demonstrates how FortiWeb combines traditional inspection with behavioral analysis to protect modern REST APIs.
