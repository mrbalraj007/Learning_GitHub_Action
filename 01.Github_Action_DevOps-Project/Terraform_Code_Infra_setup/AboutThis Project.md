sudo rm /etc/apt/sources.list.d/trivy.list
✅ Step-by-step Fix:
1. Check for Duplicate Sources
Run this to find duplicate entries:

bash
Copy
Edit
grep -r "aquasecurity.github.io" /etc/apt/sources.list /etc/apt/sources.list.d/
You'll likely see multiple entries for Trivy, possibly with different Signed-By values.

2. Remove the Conflicting Entry/Entries
Remove the Trivy source files causing the conflict:

bash
Copy
Edit
sudo rm /etc/apt/sources.list.d/trivy.list
(Adjust the filename if different based on the output of step 1.)

 that's the root cause right there. You have two conflicting lines in the same file (/etc/apt/sources.list.d/trivy.list):

One line includes signed-by=/usr/share/keyrings/trivy.gpg

The other does not — and that creates the conflict.

🔧 Fix It
You just need to clean up that file and leave only one valid line. Here's how:

Option 1: Clean manually (quick edit)
bash
Copy
Edit
sudo nano /etc/apt/sources.list.d/trivy.list
Change this:

bash
Copy
Edit
deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb noble main
deb https://aquasecurity.github.io/trivy-repo/deb noble main
To this (just keep one line):

bash
Copy
Edit
deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb noble main
Then save and exit (Ctrl+O, Enter, Ctrl+X).

Option 2: Or delete the file entirely (if you're removing Trivy anyway)
bash
Copy
Edit
sudo rm /etc/apt/sources.list.d/trivy.list



# Note: 
# a. First create a pem-key manually from the AWS console
# b. Copy it in the same directory as your terraform code

# Technical Document: GitHub Actions CI/CD Pipeline for Kubernetes Deployment

This document outlines the implementation of a Continuous Integration and Continuous Delivery (CI/CD) pipeline using GitHub Actions to build, test, containerize, and deploy a Java application to a Kubernetes cluster.

1. Introduction
This project demonstrates a comprehensive CI/CD workflow leveraging the capabilities of GitHub Actions. It automates the process of building a Java application, performing security and quality checks, running unit tests, containerizing it with Docker, and finally deploying it to a Kubernetes environment.

2. Key Technologies and Tools Used
GitHub Actions: The workflow automation platform provided by GitHub. It enables the creation of custom workflows directly within the GitHub repository.
Git: A distributed version control system used for managing the source code.
Maven: A build automation tool primarily used for Java projects.
JDK (Java Development Kit): The development environment used to compile and run Java applications.
Trivy: A comprehensive security scanner for vulnerabilities in container images, file systems, and Git repositories.
GitLeaks: A tool for scanning Git repositories for secrets and sensitive data.
SonarQube: A platform for continuous inspection of code quality to perform static code analysis.
Docker: A platform for building, shipping, and running applications in containers.
Kubernetes: A container orchestration platform for automating deployment, scaling, and1 management of containerized applications.2   
1.
thectoclub.com
thectoclub.com
2.
github.com
github.com
AWS CLI (Amazon Web Services Command Line Interface): A command-line tool to interact with AWS services, used here to configure kubectl for the EKS cluster.
kubectl: The command-line tool for interacting with Kubernetes clusters.
Terraform (Mentioned): While not explicitly shown in the pipeline steps, Terraform is mentioned as the tool used to set up the EKS cluster.
3. Step-by-Step Description of the CI/CD Pipeline
The GitHub Actions workflow is defined in a YAML file (cicd.yml) and consists of several jobs that run sequentially or in parallel based on dependencies.

Step 1: Set up Git Repository (Manual)

The project code is assumed to be hosted in a GitHub repository.
Step 2: Set up GitHub Actions (Configuration)

A .github/workflows directory is created in the repository.
A cicd.yml file is defined within this directory to configure the CI/CD pipeline.
Step 3: Add a Virtual Machine as a Runner (Self-Hosted Runner)

A Linux virtual machine is set up to act as a self-hosted runner for GitHub Actions, providing more control over the execution environment.
The runner is configured in the GitHub repository settings under "Actions" -> "Runners".
Specific commands provided by GitHub are executed on the VM to connect it to the repository.
The runs-on directive in the workflow jobs is set to the label of the self-hosted runner.
Step 4: Write the CI/CD YAML Pipeline from Scratch (cicd.yml)

The cicd.yml file defines the following jobs:

compile:

Runs on the self-hosted runner.
Checks out the project code.
Sets up JDK 17.
Uses Maven to clean and compile the Java application.
security-checks:

Runs after the compile job (needs: compile).
Runs on the self-hosted runner.
Checks out the project code.
Installs Trivy and performs a file system scan for vulnerabilities.
Installs GitLeaks and scans the repository for hardcoded secrets.
unit-tests (Conceptual):

Intended for running unit tests, although the specific commands are not detailed in the transcript. This job would likely depend on the compile job.
sonar-analysis:

Depends on the compile job.
Runs on the self-hosted runner.
Checks out the code.
Sets up JDK 17.
Configures and executes SonarQube analysis using a SonarScanner action, utilizing GitHub Secrets for the SonarQube token and host URL.
upload-artifact:

Depends on the compile job.
Runs on the self-hosted runner.
Uploads the generated JAR file as an artifact using the actions/upload-artifact action.
build-docker-image:

Depends on the sonar-analysis job.
Runs on the self-hosted runner.
Logs in to Docker Hub using credentials stored as GitHub Secrets.
Sets up buildx for building multi-architecture Docker images.
Builds the Docker image and pushes it to Docker Hub.
deploy-to-kubernetes:

Depends on the build-docker-image job.
Runs on the self-hosted runner.
Checks out the project code (to access Kubernetes manifests).
Sets up AWS CLI and configures it using AWS access key and secret key stored as GitHub Secrets.
Configures kubectl to interact with the EKS cluster using the AWS CLI.
Deploys the application to the Kubernetes cluster by applying the YAML manifests.
4. Why Use This Project/Approach?
Automation: Automates the entire software delivery lifecycle from code commit to deployment, reducing manual effort and the risk of human errors.
Efficiency: Speeds up the development and deployment process, allowing for faster release cycles.
Improved Code Quality: Integrates security and code quality checks early in the development process, leading to more robust and secure applications.
Consistency: Ensures consistent build, test, and deployment processes across different environments.
Scalability: GitHub Actions and Kubernetes are highly scalable, allowing the pipeline to handle projects of varying sizes and complexities.
Version Control Integration: Being tightly integrated with GitHub, the workflow is directly associated with the codebase, providing better traceability and management.
Infrastructure as Code (Implicit): While not the primary focus, the deployment to Kubernetes using YAML manifests aligns with the principles of Infrastructure as Code.
Learning Opportunity: Provides a practical example of implementing a modern CI/CD pipeline using popular DevOps tools.
5. Conclusion
This project demonstrates a robust and automated CI/CD pipeline using GitHub Actions. By integrating security scanning, code quality analysis, containerization, and Kubernetes deployment, it showcases best practices for modern software development and delivery. The step-by-step approach and the use of industry-standard tools make this a valuable example for anyone looking to automate their deployment workflows. The use of a self-hosted runner provides flexibility and control over the execution environment, while the integration with GitHub Secrets ensures the secure management of sensitive credentials.