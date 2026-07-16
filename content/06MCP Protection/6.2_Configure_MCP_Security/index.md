---
title: "Exercise 6.2 – Configure MCP Security"
linkTitle: "6.2 Configure MCP Security"
weight: 20
---

## Exercise 6.2 – Configure MCP Security

### Objective

Configure FortiWeb to inspect MCP messages and enforce protocol-aware security controls for the lab MCP application.

### Step 1 – Create an MCP Security Rule

Navigate to:

**Web Protection → Protocol → MCP**

Create a rule with the following settings:

| Setting | Value |
|---------|-------|
| Name | `MCP` |
| Host | `mcp.fortiweblab.local` |
| Request URL | `*` |
| Action | Alert & Deny |
| Severity | Low |

![Create MCP Security rule — add screenshot](create-mcp-security-rule.png)

{{% notice note %}}
Confirm the host name with your instructor if the lab uses a different MCP virtual host.
{{% /notice %}}

### Step 2 – Create the MCP Security Policy

Create an MCP Security Policy and enable the available inspection engines:

* Signature Detection
* Prompt Poisoning Protection
* MCP JSON Schema Validation

Associate the `MCP` rule with the policy where required.

![MCP Security Policy with inspection engines enabled — add screenshot](mcp-security-policy.png)

### Step 3 – Apply the Policy

Open the Web Protection Profile that protects the MCP application and assign the MCP Security Policy.

Save the profile and verify that the MCP content-routing or server-policy entry still references the correct backend pool and protection profile.

![MCP policy assigned to Web Protection Profile — add screenshot](mcp-policy-profile-assignment.png)

### Step 4 – Validate Legitimate Traffic

Repeat **MCP Initialize** or **MCP Tools/List** from Exercise 6.1. Confirm that valid MCP requests still succeed after the policy is enabled.

![Valid MCP request after policy activation — add screenshot](mcp-valid-request-after-policy.png)

### Verification Checklist

* Created the MCP Security rule
* Enabled signatures, prompt protection, and schema validation
* Applied the MCP policy to the correct Web Protection Profile
* Confirmed that legitimate MCP traffic still succeeds

### Next Exercise

In Exercise 6.3, you run the MCP Attack Campaign against the protected service.
