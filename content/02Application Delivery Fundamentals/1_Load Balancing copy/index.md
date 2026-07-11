---
title: "Task 1 - Load Balancing"
linkTitle: "Load Balancing"
weight: 10
---

## Task 1 – Load Balancing

This is a review-only section; the application delivery configuration is already in place.

## Access the FortiWeb Management Interface

1. Access the Guacamole desktop from [Chapter 1 — Access the Lab Environment](../../01GettingStarted/3_Access%20the%20Lab%20Enviroment/).
2. Once the desktop appears, open the web browser.
3. Select the **FortiWeb** bookmark from the browser toolbar.
4. Log in using the following credentials:

| Field | Value |
|-------|-------|
| Username | `FortiLab` |
| Password | `Fortinetlab1!` |

## Review Server Pools

Navigate to:

**Server Objects → Server → Server Pool**

Several Server Pools have already been configured for the applications used throughout this lab.

![Server Pool List — add screenshot](server-pool-list.png)

Notice that separate Server Pools have been created for each application. This allows FortiWeb to independently monitor and forward traffic to each backend service.

Select **MCP Server Pool** to review its configuration.

### What to Review

While reviewing the Server Pool, observe the following settings:

* **Health Check** — FortiWeb verifies that the backend application is available before forwarding client requests. In this lab, an ICMP health check has been configured.
* **Session Persistence** — Also known as session stickiness, persistence ensures that once a client has been assigned to a backend server, subsequent requests from that client continue to use the same server for the duration of the session.
* **Server Definition** — Backend servers may be defined using either an IP address or a hostname.
* **Service Port** — Notice that the backend application listens on TCP port **9001**, while clients connect to FortiWeb using HTTPS (TCP **443**). FortiWeb translates the client request and forwards it to the application using the configured backend port.
* **Backend Encryption** — In this lab, communication between FortiWeb and the application servers is intentionally left unencrypted to simplify the lab environment. In production deployments, HTTPS communication to backend servers is commonly used.

## Review Health Checks

One of the primary responsibilities of an application delivery controller is ensuring that client requests are sent only to healthy application servers.

A **Health Check** is a monitoring policy that FortiWeb uses to periodically verify the availability of each server in a Server Pool. If a server fails the configured health check, FortiWeb automatically removes it from the load-balancing pool and stops forwarding client traffic to that server. Once the server recovers and successfully responds to subsequent health checks, it is automatically returned to service.

This process is completely automatic and helps maintain application availability without requiring administrator intervention.

FortiWeb supports several health check methods, including:

* **ICMP (Ping)** — Verifies basic network connectivity.
* **TCP** — Confirms that the configured TCP port is accepting connections.
* **HTTP** — Verifies that a web server responds to an HTTP request.
* **HTTPS** — Confirms both SSL/TLS connectivity and application responsiveness.

Because HTTP and HTTPS health checks validate the application itself, they are generally preferred over ICMP in production environments. While a server may respond to a ping request, the web application running on that server could still be unavailable.

In this lab, an ICMP health check has been configured for simplicity.

### Review the Health Check Configuration

Navigate to:

**Server Objects → Health Check**

Open the ICMP health check that has been configured for the lab.

![Health Check Configuration — add screenshot](health-check-configuration.png)

### What to Review

Review the following configuration items:

* Health check type (ICMP)
* Polling interval
* Timeout value
* Failure threshold
* Recovery threshold

Consider how these settings influence when FortiWeb declares a server unavailable and when it is restored to service after recovery.

### Why Health Checks Matter

Without health checks, FortiWeb would continue forwarding client requests to application servers even if they were offline or unresponsive, resulting in failed client connections.

Health checks enable FortiWeb to:

* Detect application failures automatically.
* Remove failed servers from the load-balancing pool.
* Restore recovered servers without administrator intervention.
* Improve application availability and the overall user experience.

## Review Virtual Servers

A **Virtual Server**, often referred to as a Virtual IP (VIP), is the address clients use to access protected web applications.

FortiWeb listens for incoming client connections on the Virtual Server and then forwards those requests to the appropriate Server Pool.

In most deployments, the Virtual Server uses a dedicated IP address. However, FortiWeb also supports using an interface IP address when additional IP addresses are unavailable. Multiple IP addresses may also be associated with a Virtual Server when required.

One of the most common uses for a Virtual Server is **Content Routing**, where multiple web applications share the same IP address while FortiWeb determines which backend application should receive each request.

Navigate to:

**Server Objects → Server → Virtual Server**

Open the **virt-1** Virtual Server.

![Virtual Server Configuration — add screenshot](virtual-server-configuration.png)

### What to Review

Review the following configuration items:

* Virtual IP address
* Listening port
* Associated Server Pool
* SSL certificate (reviewed in [Task 3 – SSL/TLS Offloading](../2_SSL/TLS%20Offloading/))
* HTTP Content Routing configuration (reviewed in [Task 2 – Content Routing](../3_Content%20Routing/TLS%20Offloading/))

Notice that this Virtual Server accepts HTTPS traffic on behalf of multiple applications.
