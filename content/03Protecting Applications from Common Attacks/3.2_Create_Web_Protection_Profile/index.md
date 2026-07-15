---
title: "Exercise 3.2 – Create a Web Protection Profile"
linkTitle: "3.2 Web Protection Profile"
weight: 20
---

## Exercise 3.2 – Create a Web Protection Profile for DVWA

### Objective

In this exercise, you create a dedicated **Web Protection Profile** for the DVWA application. A Web Protection Profile is where FortiWeb brings together the security features that protect an application. Rather than enabling each protection independently on a server policy, FortiWeb references a single profile that contains the desired settings.

You will create a profile named **DVWA** and associate the preconfigured security policies for this application, including:

* Signature Protection
* HTTP Protocol Constraints
* HTTP Header Security
* Cookie Security
* Custom Policy

Finally, you associate the completed profile with the **dvwa** HTTP Content Routing rule reviewed in Chapter 2.

### Understanding Web Protection Profiles

A Web Protection Profile is a centralized collection of security policies applied to a protected web application.

Instead of configuring each security feature independently for every application, FortiWeb allows multiple security components to be grouped into a single reusable profile. This simplifies policy management and helps keep protection consistent across applications.

In this lab, DVWA uses its own dedicated protection profile so you can observe WAF behavior without changing the Juice Shop configuration.

![Web Protection Profile concept — optional diagram](web-protection-profile-concept.png)

---

### Step 1 – Create the Web Protection Profile

1. From the FortiWeb navigation menu, select:

   **Policy → Web Protection Profile**

2. Click **Create New**.
3. Configure the following settings:

| Setting | Value |
|---------|-------|
| Name | `DVWA` |

![Create Web Protection Profile — Name = DVWA — add screenshot](create-web-protection-profile.png)

---

### Step 2 – Configure Standard Protection

Under the **Standard Protection** section, configure the following policies:

| Setting | Value |
|---------|-------|
| Signatures | `DVWA` |
| HTTP Protocol Constraints | `DVWA` |
| X-Forwarded-For | `X-Forwarded-For` |

![Standard Protection settings for DVWA profile — add screenshot](wpp-standard-protection.png)

* The **Signatures** policy enables FortiWeb’s attack signature engine.
* The **HTTP Protocol Constraints** policy enforces compliance with HTTP standards and acceptable request methods.
* The **X-Forwarded-For** setting instructs FortiWeb to use the original client IP address supplied by an upstream load balancer or proxy instead of the IP of the intermediary device.

---

### Step 3 – Configure Client-Side Security

Scroll to the **Client Side Security** section and configure:

| Setting | Value |
|---------|-------|
| Client Management | Enabled |
| HTTP Header Security | `DVWA` |
| Cookie Security Policy | `DVWA` |

Leave the remaining Client Side Security settings at their default values.

![Client Side Security settings for DVWA profile — add screenshot](wpp-client-side-security.png)

These policies improve browser-side security by adding secure HTTP response headers and enforcing secure cookie attributes. That reduces the likelihood of client-side attacks such as session hijacking and content injection.

---

### Step 4 – Configure Advanced Protection

Scroll to the **Advanced Protection** section and configure:

| Setting | Value |
|---------|-------|
| Custom Policy | `DVWA` |

Leave all other Advanced Protection settings unchanged.

![Advanced Protection — Custom Policy = DVWA — add screenshot](wpp-advanced-protection.png)

The **DVWA** Custom Policy includes additional protections, such as rules that detect content-encoding evasion techniques and brute-force login attempts.

---

### Step 5 – Save the Profile

After verifying the configuration, click **OK** to create the Web Protection Profile.

At this point, the profile should reference the following policies:

| Protection Feature | Policy |
|--------------------|--------|
| Signature Detection | `DVWA` |
| HTTP Protocol Constraints | `DVWA` |
| HTTP Header Security | `DVWA` |
| Cookie Security | `DVWA` |
| Custom Policy | `DVWA` |

![Completed DVWA Web Protection Profile summary — add screenshot](wpp-dvwa-complete.png)

The Web Protection Profile is now ready to be assigned to the protected application.

---

### Step 6 – Associate the Profile with the Server Policy

Next, apply the newly created protection profile to the DVWA application.

1. Navigate to:

   **Policy → Server Policy**

2. Edit the server policy used for the lab (the same policy that hosts the HTTP Content Routing rules reviewed in Chapter 2).
3. Locate the **HTTP Content Routing** table.
4. Select the **dvwa** content routing policy.
5. Verify the following:

| Setting | Value |
|---------|-------|
| Server Pool | `DVWA` |
| Inherit Web Protection Profile | `No` |

Because **Inherit Web Protection Profile** is disabled, this routing rule can use its own dedicated protection profile.

6. In the **Web Protection Profile** column, select **DVWA**.
7. Ensure the **Status** is **Enabled**.
8. Click **OK** to save the Server Policy.

![HTTP Content Routing — dvwa rule with DVWA Web Protection Profile — add screenshot](server-policy-dvwa-wpp.png)

---

### Verify the Configuration

After saving the Server Policy, confirm the following:

* The **dvwa** content routing rule references the **DVWA** server pool
* The **DVWA** Web Protection Profile is assigned to the **dvwa** routing rule
* The routing rule is **Enabled**
* The **juiceshop** application continues to inherit its existing protection profile

At this point, requests matching the DVWA host or URL path are inspected using the dedicated **DVWA** Web Protection Profile, while requests destined for Juice Shop continue using their existing configuration.

---

### What You Have Accomplished

You have successfully:

* Created a dedicated Web Protection Profile for DVWA
* Associated signature, protocol, header, cookie, and custom protections with the profile
* Applied the profile to the **dvwa** HTTP Content Routing rule

### Next Exercise

In the next exercise, you use the FortiWeb Lab Traffic Launcher to send multiple mapped attack types to DVWA. After the campaign completes, you will review FortiWeb Attack Logs and compare the results with the unprotected baseline from Exercise 3.1.
