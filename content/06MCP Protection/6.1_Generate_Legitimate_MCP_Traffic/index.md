---
title: "Exercise 6.1 – Generate Legitimate MCP Traffic"
linkTitle: "6.1 Legitimate MCP Traffic"
weight: 10
---

## Exercise 6.1 – Generate Legitimate MCP Traffic

### Objective

Generate normal MCP communication and observe how FortiWeb records AI client activity before MCP-specific security controls are tested.

The traffic simulates session initialization, tool discovery, authorized tool calls, and streamed responses.

{{% notice note %}}
Run these scenarios only in the controlled training environment.
{{% /notice %}}

### Step 1 – Launch the Traffic Generator

From the Guacamole desktop, open a terminal and run:

```bash
cd ~/fortiweb-lab-traffic
./fortiweb-lab-traffic
```

From the main menu, select:

```text
3 – MCP Traffic Generator
```

![FortiWeb Lab Traffic Launcher MCP menu — add screenshot](mcp-traffic-generator-menu.png)

### Step 2 – Initialize an MCP Session

Select:

```text
4 – MCP Initialize
```

This establishes communication between the MCP client and server.

![Successful MCP initialization — add screenshot](mcp-initialize.png)

### Step 3 – Discover Available Tools

Select:

```text
5 – MCP Tools/List
```

The client retrieves the tools exposed by the MCP server. Review the returned tool names and descriptions.

![MCP tools/list response — add screenshot](mcp-tools-list.png)

{{% notice note %}}
Tool discovery is expected MCP behavior, but it also reveals the server’s capabilities. Production deployments should expose only the tools required by authorized clients.
{{% /notice %}}

### Step 4 – Generate Legitimate Training Traffic

Select:

```text
7 – MCP ML Training
```

The generator produces approximately 2,000 legitimate MCP requests with varied source addresses, timing, and authorized tool invocations. Examples include initialization, tool discovery, approved file reads, and streamed responses.

![Legitimate MCP traffic generation in progress — add screenshot](mcp-ml-training-running.png)

Allow the scenario to complete before continuing.

### Step 5 – Review the Traffic Log

In FortiWeb, navigate to:

**Log & Report → Log Access → Traffic**

Filter for the MCP host, such as `mcp.fortiweblab.local`, and review several transactions.

Relevant fields may include:

* Source and destination
* Server policy and host name
* URL and HTTP method
* User agent
* Response code
* JA4 TLS fingerprint, when available

![Traffic Log filtered for legitimate MCP requests — add screenshot](mcp-traffic-log.png)

Because this scenario generates legitimate traffic, requests should normally be processed successfully.

### Verification Checklist

* Initialized an MCP session
* Listed the available MCP tools
* Completed the MCP ML Training scenario
* Located legitimate MCP requests in the Traffic Log

### Next Exercise

In Exercise 6.2, you configure MCP-specific inspection and associate it with the protection profile used by the MCP application.
