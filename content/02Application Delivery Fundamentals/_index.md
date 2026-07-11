---
title: "Ch 2 Application Delivery Fundamentals"
linkTitle: "Ch 2: Application Delivery Fundamentals"
weight: 20
---

## Lab – Reviewing the Application Delivery Configuration

Before FortiWeb can protect an application, it must first know where that application resides. This is accomplished by defining one or more backend application servers in a **Server Pool**.

A Server Pool can contain a single application server or multiple servers that provide the same service. When multiple servers are present, FortiWeb can provide traditional application delivery features such as health monitoring, load balancing, and session persistence, while simultaneously providing Web Application Firewall (WAF) protection.

In this lab, the application delivery configuration has already been completed. Rather than creating the configuration from scratch, you will review the objects that have been configured and become familiar with how the applications are published through FortiWeb.

### **Objective**

Understand how FortiWeb is being used for application delivery.

This module is informational only. Configuration has been pre-built.

### **Topics Covered**

#### **Load Balancing**

* Virtual servers  
* Server pools  
* Health checks

#### **SSL/TLS Offloading**

* Certificate handling  
* SSL termination  
* Backend communication

#### **Content Routing**

* Host-based routing  
* URL-based routing  
* Multi-application publishing

### **Demonstrations**

* Review existing Virtual Servers  
* Review Server Pools  
* Review Routing Rules  
* Observe traffic flow

### **Key Takeaways**

* Understand application delivery concepts  
* See how security services integrate into the traffic path
