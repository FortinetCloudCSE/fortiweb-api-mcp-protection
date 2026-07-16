---
title: "Ch 4 – Machine Learning-Based Anomaly Detection"
linkTitle: "Ch 4: ML Anomaly Detection"
weight: 40
---

## **Objective**

Configure FortiWeb’s **Machine Learning-Based Anomaly Detection** to automatically learn the normal behavior of the OWASP Juice Shop application.

Using legitimate application traffic, FortiWeb builds a behavioral model of the application. Once learning is complete, you place the policy into **Enforcement Mode** and verify that FortiWeb detects and blocks requests that deviate from learned behavior.

Unlike traditional signature-based protection alone, Machine Learning enables FortiWeb to detect abnormal application behavior—providing an additional layer of protection against previously unseen attacks.

### **Learning Objectives**

After completing this chapter, you will be able to:

* Explain the difference between signature-based protection and Machine Learning-Based Anomaly Detection
* Describe how FortiWeb learns application behavior
* Configure Machine Learning for a FortiWeb policy
* Generate legitimate application traffic to build a behavioral model
* Verify that Machine Learning has completed the learning process
* Enable Enforcement Mode
* Generate anomalous application traffic
* Review Machine Learning detections in FortiWeb logs

---

### Understanding Machine Learning-Based Anomaly Detection

Traditional Web Application Firewalls (WAFs) primarily rely on **signature-based detection**. A signature identifies known attack techniques such as SQL Injection, Cross-Site Scripting (XSS), Command Injection, Directory Traversal, and many other common web application attacks.

Signature-based protection is highly effective against attacks that are already known. However, attackers continuously develop new techniques that may not yet have corresponding signatures.

To address this challenge, FortiWeb incorporates **Machine Learning-Based Anomaly Detection**.

Rather than asking only:

> “Does this request match a known attack signature?”

FortiWeb also asks:

> “Does this request look like normal behavior for this application?”

Instead of relying exclusively on known attack patterns, FortiWeb observes how legitimate users interact with an application and automatically builds a behavioral model describing what normal application traffic looks like.

Once this baseline has been established, every new request is compared against the learned model. Requests that significantly deviate from normal behavior are classified as anomalous and can be logged, alerted upon, or blocked according to the configured policy.

This approach helps FortiWeb identify suspicious requests even when no signature exists—providing an additional layer of protection against zero-day attacks, application abuse, and other unknown threats.

![Signature vs Machine Learning comparison — optional diagram](ml-vs-signatures.png)

---

### How Machine Learning-Based Anomaly Detection Works

FortiWeb continuously analyzes legitimate HTTP and HTTPS traffic to understand how a protected application normally behaves. Rather than relying solely on predefined attack signatures, it builds mathematical models that describe the expected structure and behavior of application requests.

During learning, FortiWeb observes characteristics such as:

* Requested URLs
* HTTP methods (`GET`, `POST`, `PUT`, `DELETE`, and others)
* URL and form parameters
* Relationships between URLs and parameters
* Parameter value patterns

Instead of memorizing every value submitted by users, FortiWeb generalizes collected information into mathematical patterns. For example, two different email addresses are recognized as having the same structure even though the values themselves differ. Numeric identifiers, usernames, and other inputs are modeled by expected characteristics rather than exact values.

Once sufficient samples have been collected, FortiWeb creates mathematical models describing normal application behavior. Every subsequent request is compared against these models.

FortiWeb performs this analysis using **two complementary layers** of Machine Learning, improving detection accuracy while reducing false positives.

![Two-layer Machine Learning model — optional diagram](ml-two-layer-model.png)

#### Layer 1 – Behavioral Modeling

The first layer learns how the application behaves.

FortiWeb analyzes legitimate requests and builds mathematical models describing relationships between URLs, HTTP methods, parameters, and expected parameter values. After learning completes, every incoming request is compared against this behavioral model.

Examples of anomalies detected during this stage include:

* Requests to URLs that have never been observed
* Unexpected HTTP methods for a URL
* Unknown parameters
* Parameter values that do not match previously learned patterns
* Request patterns that differ significantly from normal application behavior

The purpose of this layer is **not** to determine whether a request is malicious. Its purpose is to determine whether the request appears **unusual** for the protected application.

#### Layer 2 – Threat Classification

Not every unusual request is an attack. Applications evolve, users behave unpredictably, and developers introduce new functionality.

To reduce false positives, requests identified as anomalous by the behavioral model are evaluated by a second Machine Learning layer. This layer uses pre-trained threat models developed from real-world attack samples to determine whether the anomaly is likely malicious.

These models recognize attack categories such as:

* SQL Injection
* Cross-Site Scripting (XSS)
* Command Injection
* Directory Traversal
* Other common web application attacks

By combining behavioral anomaly detection with threat classification, FortiWeb can protect against both known and previously unseen techniques while minimizing unnecessary blocking of legitimate users.

---

### Machine Learning Lifecycle

Machine Learning-Based Anomaly Detection progresses through several stages as FortiWeb learns and protects an application. These stages can be monitored from the **Machine Learning Overview** page in the FortiWeb management interface.

![Machine Learning lifecycle stages — optional diagram](ml-lifecycle.png)

#### Stage 1 – Collecting

During the **Collecting** stage, FortiWeb gathers representative samples of legitimate application traffic.

Only successful application requests that accurately represent normal behavior are used to build the behavioral model. The quality of the model depends heavily on the quality and diversity of the collected traffic—so the learning phase should include realistic user activity rather than repetitive or artificial requests alone.

#### Stage 2 – Building

Once enough legitimate traffic has been collected, FortiWeb begins generating the mathematical models used for anomaly detection.

During this stage, relationships between URLs, HTTP methods, parameters, and parameter value patterns are analyzed to create a behavioral model representing normal application activity. The time required depends on the amount and diversity of collected traffic.

#### Stage 3 – Running

After the behavioral models have stabilized, FortiWeb transitions into the **Running** state.

Every incoming request is evaluated against the learned behavioral model. Requests that match learned behavior are processed normally. Requests identified as anomalous are passed to the second Machine Learning layer for threat classification before the configured policy action is applied.

#### Stage 4 – Discarded

Not every application parameter can be modeled successfully.

If FortiWeb determines that a parameter does not have sufficient consistency to build a reliable behavioral model, that parameter is placed into the **Discarded** state. Discarded parameters are excluded from anomaly detection while the remainder of the application continues to benefit from Machine Learning protection.

---

### Why This Lab Uses a Traffic Generator

In production, FortiWeb typically learns application behavior over several days or weeks while legitimate users interact with the application. Waiting that long is impractical in a classroom environment.

To accelerate learning, this lab includes a custom **FortiWeb Lab Traffic Launcher** that simulates realistic user activity against OWASP Juice Shop, including:

* Browsing products
* Viewing product details
* Searching for products
* Shopping cart operations
* User navigation and normal application workflows

This traffic allows FortiWeb to build an accurate behavioral model within minutes. After learning completes, the same tool generates attack traffic so you can observe how FortiWeb detects requests that violate the learned application behavior.

---

### **Topics Covered**

#### **Machine Learning Concepts**

* Signature-based vs behavioral detection
* Traffic baselining and behavioral analysis
* Two-layer anomaly detection and threat classification
* Model lifecycle: Collecting → Building → Running → Discarded

#### **Hands-On Configuration**

* Enabling Machine Learning in Learning mode
* Generating legitimate Juice Shop traffic
* Verifying the behavioral model
* Switching to Enforcement Mode
* Testing unexpected and malicious requests

### **Hands-On Tasks**

* [Exercise 4.1 – Configure Machine Learning](4.1_Configure_Machine_Learning/)
* [Exercise 4.2 – Generate Legitimate Traffic](4.2_Generate_Legitimate_Traffic/)
* [Exercise 4.3 – Switch to Enforcement Mode](4.3_Switch_to_Enforcement_Mode/)
* [Exercise 4.4 – Test Unexpected Requests](4.4_Test_Unexpected_Requests/)

### **Key Takeaways**

* Understand how behavioral modeling complements traditional WAF signatures
* See how FortiWeb learns, enforces, and logs anomalous application behavior
