---
title: "Exercise 5.1 – Explore API Endpoints"
linkTitle: "5.1 Explore Endpoints"
weight: 10
---

## Exercise 5.1 – Explore the PetStore API

### Objective

Become familiar with the **PetStore** REST API and observe how clients communicate with the application before automated traffic generation or attacks are performed.

This legitimate traffic helps you understand the API surface that FortiWeb will later discover and learn from.

---

### Step 1 – Open PetStore from Guacamole

1. Log in to the Guacamole remote desktop.
2. Launch the web browser.
3. From the browser’s shortcut/bookmarks bar, open the **PetStore** application (or Swagger UI for PetStore, if provided in the lab).

![PetStore application or Swagger UI home — add screenshot](petstore-home.png)

{{% notice tip %}}
If your lab provides both a PetStore UI and a Swagger documentation page, open the Swagger UI as well. It is often the easiest way to see available endpoints, methods, and example request bodies.
{{% /notice %}}

---

### Step 2 – Review Available API Areas

PetStore typically organizes APIs into areas such as:

| Area | Example operations |
|------|--------------------|
| Pet | Find pets by status, get pet by ID, add or update a pet |
| Store | View inventory, place an order, get an order by ID |
| User | Create a user, log in, log out, update user details |

Browse the available endpoints and note a few paths and HTTP methods (for example, `GET /pet/findByStatus` or `POST /store/order`).

![PetStore Swagger endpoints list — add screenshot](petstore-swagger-endpoints.png)

---

### Step 3 – Perform Several Legitimate API Operations

Using the PetStore UI or Swagger “Try it out” controls, perform several normal operations, such as:

* Find pets by status (for example, `available` or `pending`)
* Retrieve a pet by ID
* View store inventory
* Place a sample order
* Create or look up a user (if available in your lab build)

![PetStore legitimate API operation in browser or Swagger — add screenshot](petstore-legitimate-request.png)

While using the application, observe that each action generates API requests between the client and the backend. These are structured HTTP requests with JSON payloads—not traditional HTML page loads.

---

### Step 4 – Observe Request and Response Characteristics

For at least one successful operation, note:

* The requested URL / endpoint
* The HTTP method (`GET`, `POST`, `PUT`, or `DELETE`)
* Whether a JSON body was sent
* Whether the response returned JSON data
* Any status codes such as `200`, `400`, or `404`

![Browser developer tools or Swagger response showing JSON — add screenshot](petstore-json-response.png)

{{% notice note %}}
You do not need to capture every endpoint manually. Exercise 5.2 uses the FortiWeb Lab Traffic Launcher to generate broader legitimate coverage so FortiWeb can discover and learn the API model more completely.
{{% /notice %}}

---

### What You Have Accomplished

* Opened the PetStore API application
* Reviewed major API areas (Pet, Store, User)
* Performed several legitimate API operations
* Observed that PetStore clients exchange structured JSON over HTTP

### Next Exercise

In Exercise 5.2, you use the FortiWeb Lab Traffic Launcher to generate legitimate PetStore traffic so FortiWeb can discover endpoints and build a Machine Learning–based API model.
