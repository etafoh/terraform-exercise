	# AWS Terraform Exercise
 
This has been tested using Terraform v0.11.x we advise you use this version as we will test your code with the same.
 
Please respond with a zip including your git files so the history of commits is included.
 
Here we have some Terraform which builds a simple VPC. For now, we have just one instance running the web server.
Nginx in its default configuration, serving up the default welcome page.
 
To run this use the following command:
 
```
terraform apply -var-file=dublin.tfvars
```
 
You can test the solution using the following command:
 
```
terraform output nginx_domain | xargs curl
```
 
Complete all exercises, making sure to use git appropriately. Feel free to modify the existing code as much as possible in order to best achieve this.
 
Document your solution and notes on how to run it in a `NOTES.md` markdown file and make sure you commit this.
 
Exercises:
 
1. We would like to be able to run the same stack closer to our customers in the US. Please build the same stack in
the us-east-1 (Virginia) region. Note that Virginia has a different number of availability zones which we would like
to take advantage of. As for a CIDR block for the VPC use whatever you feel like, providing it's compliant with RFC-1918 and does not overlap with the dublin network.
 
2. The EC2 instance running Nginx went down over the weekend and we had an outage, it's been decided that we need a solution
that is more resilient than just a single instance. Please implement a solution that you'd be confident would continue
to run in the event one instance goes down.
 
3. We are looking to improve the security of our network and have decided we need a bastion server to avoid logging on
directly to our servers. Add a bastion server, the bastion should be the only route to SSH onto any server in the
entire VPC.
 
4. The team have decided to use the Java framework Spring Boot to build features for our website. Deploy the following sample
application into the VPC, reconfigure Nginx as a reverse proxy to the Java app. Provide a modification to the Terraform
output/curl command to get the hello world text that the application serves.
 
https://github.com/spring-projects/spring-boot/tree/master/spring-boot-samples/spring-boot-sample-tomcat

#Elv what the hell are you doing

