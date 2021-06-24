# HTTP Trigger (.NET 5)

Watch the recording of this lesson [on YouTube 🎥](https://youtu.be/5k35dlBAXxA).

## Goal 🎯

The goal of this lesson is to create your first function which can be triggered by doing an HTTP GET or POST to the function endpoint.

This lessons consists of the following exercises:

|Nr|Exercise
|-|-
|0|[Prerequisites](#0-prerequisites)
|1|[Creating a Function App](#1-creating-a-function-app)
|2|[Changing the template for GET requests](#2-changing-the-template-for-get-requests)
|3|[Read a value from the query string](#3-read-a-value-from-the-query)
|4|[Adding a new function for POST requests](#4-adding-a-new-function-for-post-requests)
|5|[Change the route for a custom greeting](#5-change-the-route-for-a-custom-greeting)
|6|[Homework](#6-homework)
|7|[More info](#7-more-info)

> 📝 **Tip** - If you're stuck at any point you can have a look at the [source code](../../../src/dotnetcore31/AzureFunctions.Http) in this repository.

---

## 0. Prerequisites

| Prerequisite | Exercise
| - | -
| An empty local folder / git repo | 1-6
| Azure Functions Core Tools | 1-6
| VS Code with Azure Functions extension| 1-6
| REST Client for VS Code or Postman | 1-6

See [.NET prerequisites](../prerequisites/prerequisites-dotnet.md) for more details.

## 1. Creating a Function App

In this exercise, you'll be creating a Function App with the default HTTPTrigger and review the generated code.

### Steps

1. In VSCode, create the Function App by running `AzureFunctions: Create New Project` in the Command Palette (CTRL+SHIFT+P).
2. Browse to the location where you want to save the function app (e.g. _AzureFunctions.Http_).

    > 📝 **Tip** - Create a folder with a descriptive name since that will be used as the name for the project.

3. Select the language you'll be using to code the function, in this lesson we'll be using `C#`.
4. Select `.NET 5 isolated` as the runtime.
5. Select `HTTPTrigger` as the template.
6. Give the function a name (e.g. `HelloWorldHttpTrigger`).
7. Enter a namespace for the function (e.g. `AzureFunctionsUniversity.Demo`).
    > 📝 **Tip** - Namespaces are used to organize pieces of code into a hierarchy. Make sure you don't use the exact same name as the function/class. Namespaces and classes should be named uniquely to prevent compiler and readability issues.
8. Select `Function` for the AccessRights.
    > 🔎 **Observation** - Now a new Azure Functions project is being generated. Once it's done, look at the files in the project. You will see the following:

    |File|Description
    |-|-
    |AzureFunctions.Http.csproj|The C# project file which specifies the .NET version, Azure Functions version and package references.
    |HelloWorldHttpTrigger.cs|The C# class containing the HTTPTrigger function method.
    |Program.cs|The C# class is responsible for starting the isolated process your function will be running in.
    |host.json|Contains [global configuration options](https://docs.microsoft.com/en-us/azure/azure-functions/functions-host-json) for all the functions in a function app.
    |local.settings.json|Contains [app settings and connectionstrings](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=windows%2Ccsharp%2Cbash#local-settings-file) for local development.

    > ❔ **Question** - Review the generated HTTPTrigger function. What is it doing?
9. Build the project (CTRL+SHIFT+B).

10. Start the Function App by pressing `F5`.
    > 🔎 **Observation** - Eventually you should see an HTTP endpoint in the output.
11. Now call the function by making a GET request to the above endpoint using a REST client:

    ```http
    GET http://localhost:7071/api/HelloWorldHttpTrigger
    ```

    > ❔ **Question** - What is the result of the function? Is it what you expected?

## 2. Changing the template for GET requests

Let's change the template to find out what parameters can be changed.
Depending on the trigger, arguments can be added/removed and parameter types can be changed.
Start with only allowing GET requests.

### Steps

1. Remove the `"post"` string from the `HttpTrigger` attribute. Now the function can only be triggered by a GET request.
    > 📝 **Tip** - Some people don't like to use strings and prefer something that is known as _strong typing_. Strong typing can prevent you from making certain mistakes such as typos in strings since specific .NET types are used instead. To allow the function to be triggered by a GET request replace the `"get"` string with `nameof(HttpMethod.Get)`. You'll need to add using to the `System.Net.Http` namespace to use the `HttpMethod` class. Now you're using a strongly typed version of the HTTP GET verb instead of a string reference.


2. Start the function app and check the output if the function can only be triggered by a GET request.


## 3. Read a value from the query string

Let's change the function to also allow POST requests and test it by posting a request with JSON content in the body.

### Steps

1. Add a new C# class file named `Person.cs` to the project.
2. Make sure the content of the file looks like this (adjust the namespace so it matches yours):

    ```csharp
    namespace AzureFunctionsUniversity.Demo
    {
        public class Person
        {
            public string Name { get; set; }
        }
    }
    ```

3. Update the `HttpTrigger` attribute of the function to include the POST HTTP verb. You can choose to add the verb via the strongly typed way by adding `nameof(HttpMethods.Post)` or use the `"post"` string.
4. The function method now only handles GET requests. We need to add some logic to use the querystring for GET requests and use the request body for POST requests. This can be done by checking the Method property of the request (if the request type is `HttpRequestMessage`) as follows:

    ```csharp
    string name = default;
    if (req.Method.Method == HttpMethods.Get)
    {
        // Get name from querystring
        // name = ...
    }
    else if (req.Method.Method == HttpMethods.Post)
    {
        // Get name from body
        // name = ...
    }
    ```

5. Move the querystring logic inside the `if` statement that handles the GET request.
6. Now let's add the code to extract the name from the body for a POST request. 

    > 📝 **Tip** - When the request type is `HttpRequestMessage` there's a very nice method available on the Content property called `ReadAsAsync<T>`. This method returns a typed object from the request content. In our case we can return a `Person` object from the request as follows:

    ```csharp
    var person = await req.Content.ReadAsAsync<Person>();
    name = person.Name;
    ```

7. Change the method definition back to its asynchronous form since we're using async methods again:

    ```csharp
    public static async Task<IActionResult> Run(...)
    ```

8. Now run the function and do a POST request and submit JSON content with a `Name` property. If you're using the VSCode REST client you can use this in a .http file:

    ```http
    POST http://localhost:7071/api/HelloWorldHttpTrigger
    Content-Type: application/json

    {
        "name": "Your name"
    }
    ```

    > ❔ **Question** - Is the outcome of the POST as expected?

    > ❔ **Question** - What is the response when you use an empty `name` property?

## 4. Adding a new function for POST requests

Instead of using the `HttpRequest` or `HttpRequestMessage` type for the `req` parameter a custom .NET type can be used as the parameter type, in this case `Person`. This is only useful when working solely with the request body and not the querystring, since the HttpRequest object will be unavailable. Let's add a new function to the existing class file which only responds to POST requests.

### Steps

1. Create a copy of the `HelloWorldHttpTrigger.cs` file and rename the file, the class and the function to `PersonTypeHttpTrigger.cs`.

    > 📝 **Tip** - Function names need to be unique within a Function App.
2. Remove the GET verb from the `HttpTrigger` attribute since this function will only be triggered by POST requests.
3. Change the `HttpRequestMessage` type to `Person` and rename the `req` parameter to `person`. The HttpTrigger attribute should look like this:

    ```csharp
    [HttpTrigger(AuthorizationLevel.Function, nameof(HttpMethods.Post), Route = null)]Person person,
    ```

4. Remove the logic inside the function which deals GET Http verb and with the querystring.
5. Update the logic which checks if the `name` variable is empty. You can now use `person.Name` instead.
6. Run the Function App.
    > 🔎 **Observation** - You should see the new HTTP endpoint in the output of the console.

7. Trigger the new endpoint by making a POST request.

    > ❔ **Question** - Is the outcome as expected?

## 5. Change the route for a custom greeting

Instead returning *"Hello {name}"* all the time, it would be nice if we can supply our own greeting. So we could return *"Hi {name}"* or  *"Good evening {name}"*. We can do this by changing the route of the function so it contains the greeting. The function will only triggered for GET requests.

### Steps

1. Create a copy of the `HelloWorldHttpTrigger.cs` file and rename the file, the class and the function to `CustomGreetingHttpTrigger.cs`.
2. Remove the `nameof(HttpMethods.Post)` parameter from the `HttpTrigger` binding.
3. Now update the `Route` parameter in the `HttpTrigger` binding as follows:

    ```csharp
    Route = "CustomGreetingHttpTrigger/{greeting:alpha?}")
    ```

    > 🔎 **Observation** - The `Route` uses a route argument named `greeting` and it has an `alpha` constraint. This means that `greeting` may only contain characters from the alphabet (a-z). The question mark indicates the `greeting` parameter is optional. More info on route parameter constraints in the [official docs](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/routing?view=aspnetcore-3.1#route-constraint-reference).

4. Add the following parameter to the function method:

    ```csharp
    string greeting,
    ```

    > 🔎 **Observation** - By specifying `string greeting` as an additional parameter of the method, we can now use the greeting value (that is retrieved from the route) in our function code.

5. Replace the existing body of the function method with the following:

    ```csharp
    var collection = req.RequestUri.ParseQueryString();
    string name = collection["name"];

    greeting = greeting ?? "Hello";

    ObjectResult result;
    if(string.IsNullOrEmpty(name))
    {
        var responseMessage = "Pass a name in the query string for a personalized response.";
        result = new BadRequestObjectResult(responseMessage);
    }
    else
    {
        var responseMessage = $"{greeting}, {name}. This HTTP triggered function executed successfully.";
        result = new OkObjectResult(responseMessage);
    }

    return result;
    ```

6. Run the Function App.
    > 🔎 **Observation** - You should see the new HTTP endpoint in the output of the console.

7. Trigger the new endpoint by making a GET request to the following endpoint.

    ```http
    GET http://localhost:7071/api/CustomGreetingHttpTrigger/hi?name=YourName
    ```

    > ❔ **Question** - Is the outcome as expected?

## 6. Homework

Ready to get hands-on? Checkout the [homework assignment for this lesson](http-homework-dotnet.md).

## 7. More info

- For more info about the HTTP Trigger have a look at the official [Azure Functions HTTP Trigger](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-http-webhook-trigger?tabs=csharp) documentation.

- A brief overview [video](https://youtu.be/Wbw6MS5VoDo) by Gwyneth Pena

---
[🔼 Lessons Index](../../README.md)
