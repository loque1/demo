# Architecture and Design
The basic premise of the design is to create a serverless design to meet the requirements. 
To this end the deign will make use of AWS provided services were applicable. The reason for this choice is that by using AWS services we will have High Availability thrown in for free; as the underlying services are HA. 

Technology choices used are outlined in PDF.

We will define AWS gateway API that accepts a post request which will initiate the lambda to insert the data into DynomoDB. 
DynomoDB is HA database service provided by AWS
With automated backups that can be enabled along with point in time recovery and encryption at rest using KMS.
We can also associate an auto scaling policy to DynomoDB such that it can scale with demand.
Lambda by default handles auto scaling on demand based on the concurrent execution limits for the region and if run inside a VPC then limits defined inside the VPC i.e elastic interface available to the subnet. 
The reason to run a Lambda inside the VPC is a choice about data sovereignty and allowing the Lambda to use resource inside the VPC.

| HTTP METHOD | URI-PATH  |Description                 |
| GET         |/updatedb   | Reurns an empty JSON Doc  |
| POST        |/updatedb   | Updates Dynamdb           |
| PUT         |/updatedb   | Not supported             |
| DELETE      |/updatedb   | Not Supported             |
