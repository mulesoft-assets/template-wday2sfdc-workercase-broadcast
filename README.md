
# Anypoint Template: Workday Salesforce Worker Case Broadcast

<!-- Header (start) -->
As worker information is added or removed in Workday, you may need to create cases in Salesforce to use as a service management tool to manage your employees. This template allows you to broadcast (one way sync) those changes to workers in Workday and create cases in Salesforce in real time.

The detection criteria, and fields to move are configurable. Additional systems can easily added to be notified of changes. Real time synchronization is achieved via rapid polling of Workday or can be extended to include outbound notifications. This template leverages watermarking functionality to ensure that only the most recent items are synchronized and batch to efficiently process many records at a time.

![e2a37df3-a59c-4498-a1be-15d42dd4eecb-image.png](https://exchange2-file-upload-service-kprod.s3.us-east-1.amazonaws.com:443/e2a37df3-a59c-4498-a1be-15d42dd4eecb-image.png)

<!-- Header (end) -->

# License Agreement
This template is subject to the conditions of the <a href="https://s3.amazonaws.com/templates-examples/AnypointTemplateLicense.pdf">MuleSoft License Agreement</a>. Review the terms of the license before downloading and using this template. You can use this template for free with the Mule Enterprise Edition, CloudHub, or as a trial in Anypoint Studio.
# Use Case
<!-- Use Case (start) -->
As a Workday admin I want to broadcast Workers to Salesforce Case instances.

This Anypoint template serves as a foundation for the process of broadcasting Worker from Workday instance to Salesforce, being able to specify filtering criteria and desired behavior when a case already exists in the destination system.

As implemented, this template leverages the Mule batch module. The batch job is divided Process and On Complete stages.
Firstly the template queries Workday for all the existing active workers that match the filter criteria. The criteria is based on manipulations within the given date range. The last step of the Process stage groups the cases and create them in Salesforce. Finally during the On Complete stage the template outputs statistics data into the console.
<!-- Use Case (end) -->

# Considerations
<!-- Default Considerations (start) -->

<!-- Default Considerations (end) -->

<!-- Considerations (start) -->
Salesforce Customization: It is necessary to add a custom field ExtId (Text 255) to a Salesforce Case object. For more information, see [Salesforce - Create Custom Fields](https://help.salesforce.com/HTViewHelpDoc?id=adding_fields.htm). **Note:** This template illustrates the synchronization use case between Salesforce and a Workday.
<!-- Considerations (end) -->

## Salesforce Considerations

- Where can I check that the field configuration for my Salesforce instance is the right one? See: <a href="https://help.salesforce.com/HTViewHelpDoc?id=checking_field_accessibility_for_a_particular_field.htm&language=en_US">Salesforce: Checking Field Accessibility for a Particular Field</a>.
- How can I modify the Field Access Settings? See: [Salesforce: Modifying Field Access Settings](https://help.salesforce.com/HTViewHelpDoc?id=modifying_field_access_settings.htm&language=en_US "Salesforce: Modifying Field Access Settings").

### As a Data Destination

There are no considerations with using Salesforce as a data destination.

## Workday Considerations

### As a Data Source

There are no considerations with using Workday as a data origin.

# Run it!
Simple steps to get this template running.
<!-- Run it (start) -->

<!-- Run it (end) -->

## Running On Premises
In this section we help you run this template on your computer.
<!-- Running on premise (start) -->

<!-- Running on premise (end) -->

### Where to Download Anypoint Studio and the Mule Runtime
If you are new to Mule, download this software:

- [Download Anypoint Studio](https://www.mulesoft.com/platform/studio)
- [Download Mule runtime](https://www.mulesoft.com/lp/dl/mule-esb-enterprise)

**Note:** Anypoint Studio requires JDK 8.
<!-- Where to download (start) -->

<!-- Where to download (end) -->

### Importing a Template into Studio
In Studio, click the Exchange X icon in the upper left of the taskbar, log in with your Anypoint Platform credentials, search for the template, and click Open.
<!-- Importing into Studio (start) -->

<!-- Importing into Studio (end) -->

### Running on Studio
After you import your template into Anypoint Studio, follow these steps to run it:

1. Locate the properties file `mule.dev.properties`, in src/main/resources.
2. Complete all the properties required per the examples in the "Properties to Configure" section.
3. Right click the template project folder.
4. Hover your mouse over `Run as`.
5. Click `Mule Application (configure)`.
6. Inside the dialog, select Environment and set the variable `mule.env` to the value `dev`.
7. Click `Run`.

<!-- Running on Studio (start) -->

<!-- Running on Studio (end) -->

### Running on Mule Standalone
Update the properties in one of the property files, for example in mule.prod.properties, and run your app with a corresponding environment variable. In this example, use `mule.env=prod`.

## Running on CloudHub
When creating your application in CloudHub, go to Runtime Manager > Manage Application > Properties to set the environment variables listed in "Properties to Configure" as well as the mule.env value.
<!-- Running on Cloudhub (start) -->
Once your app is all set and started, there is no need to do anything else. Every time a custom object is created or modified, it automatically synchronizes to Workday.
<!-- Running on Cloudhub (end) -->

### Deploying a Template in CloudHub
In Studio, right click your project name in Package Explorer and select Anypoint Platform > Deploy on CloudHub.
<!-- Deploying on Cloudhub (start) -->

<!-- Deploying on Cloudhub (end) -->

## Properties to Configure
To use this template, configure properties such as credentials, configurations, etc.) in the properties file or in CloudHub from Runtime Manager > Manage Application > Properties. The sections that follow list example values.
### Application Configuration
<!-- Application Configuration (start) -->
#### Properties to Configure

- scheduler.frequency `10000`
- scheduler.start.delay `500`
- watermark.default.expression `2017-12-13T03:00:59Z`

#### Workday Connector Configuration

- wday.username `joan`
- wday.tenant `acme_pt1`
- wday.password `joanPass123`
- wday.host `your_impl-cc.workday.com`

#### Salesforce Connector

- sfdc.username `user@company.com`
- sfdc.password `secret`
- sfdc.securityToken `1234fdkfdkso20kw2sd`

- sfdc.description `"Welcome Package"`
<!-- Application Configuration (end) -->

# API Calls
<!-- API Calls (start) -->
Salesforce imposes limits on the number of API Calls that can be made. Therefore calculating this amount may be an important factor to consider. The template calls to the API can be calculated using the formula:

- ***1 + X + X / 200*** -- Where ***X*** is the number of users to synchronize on each run.
- Divide by ***200*** because by default, users are gathered in groups of 200 for each upsert API call in the commit step. Also consider that this calls are executed repeatedly every polling cycle.

For instance if 10 records are fetched from origin instance, then 12 API calls are made (1 + 10 + 1).
<!-- API Calls (end) -->

# Customize It!
This brief guide provides a high level understanding of how this template is built and how you can change it according to your needs. As Mule applications are based on XML files, this page describes the XML files used with this template. More files are available such as test classes and Mule application files, but to keep it simple, we focus on these XML files:

* config.xml
* businessLogic.xml
* endpoints.xml
* errorHandling.xml
<!-- Customize it (start) -->

<!-- Customize it (end) -->

## config.xml
<!-- Default Config XML (start) -->
This file provides the configuration for connectors and configuration properties. Only change this file to make core changes to the connector processing logic. Otherwise, all parameters that can be modified should instead be in a properties file, which is the recommended place to make changes.
<!-- Default Config XML (end) -->

<!-- Config XML (start) -->

<!-- Config XML (end) -->

## businessLogic.xml
<!-- Default Business Logic XML (start) -->
The functional aspect of this template is implemented in this XML file, directed by a flow that polls for Workday creates or updates. The several message processors constitute four high level actions that fully implement the logic of this template:

1. The template goes to Workday and queries all the existing workers that match the filter criteria.
2. During the Process stage, each Workday Worker is filtered depending on if it has an existing matching case in the Salesforce organization. The logic ensures matching a worker with an account and a contact (and creating if it does not exist).
3. The last step of the Process stage groups the cases and creates or updates them in the Salesforce organization.
4. During the On Complete stage, the template logs output statistics data to the console.
<!-- Default Business Logic XML (end) -->

<!-- Business Logic XML (start) -->

<!-- Business Logic XML (end) -->

## endpoints.xml
<!-- Default Endpoints XML (start) -->
This file contains the endpoints for triggering the template and for retrieving the objects that meet the defined criteria in a query. You can execute a batch job process with the query results.
<!-- Default Endpoints XML (end) -->

<!-- Endpoints XML (start) -->

<!-- Endpoints XML (end) -->

## errorHandling.xml
<!-- Default Error Handling XML (start) -->
This file handles how your integration reacts depending on the different exceptions. This file provides error handling that is referenced by the main flow in the business logic.
<!-- Default Error Handling XML (end) -->

<!-- Error Handling XML (start) -->

<!-- Error Handling XML (end) -->

<!-- Extras (start) -->

<!-- Extras (end) -->
