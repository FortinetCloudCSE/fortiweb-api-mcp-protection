---
title: "Exercise 6.2 – Open the Assistant"
linkTitle: "6.2 Open the Assistant"
weight: 20
---

## Exercise 6.2 – Open the Assistant

### Objective

This step opens the assistant so you can see FortiWeb on the AI to tool path.

From the Guacamole browser:

```text
http://127.0.0.1:3000
```

Confirm **Protected path connected** and **mode normal**. On the **Headend** rail, select **normal** if it is not already **ACTIVE**. The left rail should list enterprise tools such as `kb.search` and `crm.lookup`.

A yellow banner means the assistant is talking to loopback instead of FortiWeb. Do not continue until the header shows **Protected path connected**.

![AcmeCorp assistant with Protected path connected](ai-agent-home.png)

### Next Exercise

In Exercise 6.3 you inventory those tools—name, description, parameters, and the enterprise system each one implies.
