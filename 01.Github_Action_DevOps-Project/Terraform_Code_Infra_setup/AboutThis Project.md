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

<<<<<<< HEAD
=======
New project file created. I'll start from here.
====
# Technical Document: GitHub Actions CI/CD Pipeline with Live Project

## **Introduction**
This document provides a step-by-step guide to setting up a CI/CD pipeline using GitHub Actions. The project demonstrates the integration of various tools and technologies to automate the build, test, and deployment processes. The pipeline is designed to deploy an application to a Kubernetes cluster using Docker and Terraform.

---

## **Key Points**
1. **GitHub Actions Overview**:
   - GitHub Actions is used to automate CI/CD workflows.
   - It eliminates the need for setting up and maintaining Jenkins servers.

2. **Project Phases**:
   - **Phase 1**: Set up a GitHub repository.
   - **Phase 2**: Add a virtual machine as a self-hosted runner.
   - **Phase 3**: Write a CI/CD pipeline from scratch using YAML.
   - **Phase 4**: Integrate tools like Trivy, SonarQube, Docker, and Kubernetes.

3. **Pipeline Stages**:
   - **Compile**: Build the application.
   - **Security Checks**: Scan for vulnerabilities and hardcoded secrets.
   - **Unit Testing**: Run automated test cases.
   - **Build and Publish**: Create Docker images and upload artifacts.
   - **Deploy to Kubernetes**: Deploy the application to an EKS cluster.

4. **Tools and Technologies Used**:
   - **GitHub Actions**: CI/CD automation.
   - **Trivy**: Security scanning for vulnerabilities.
   - **SonarQube**: Code quality and security analysis.
   - **Docker**: Containerization of the application.
   - **Kubernetes (EKS)**: Orchestration of containerized applications.
   - **Terraform**: Infrastructure as Code (IaC) for setting up EKS clusters.
   - **AWS CLI**: Manage AWS services and configure Kubernetes clusters.

---

### **Step-by-Step Guide**

#### **1. Setting Up the GitHub Repository**
- Create a new GitHub repository.
- Clone the repository locally and add the project files.
- Commit and push the changes to the repository.

#### **2. Adding a Self-Hosted Runner**
- Set up a virtual machine (Linux-based) as a self-hosted runner.
- Install required dependencies like `sudo`, `unzip`, and `docker`.
- Connect the runner to GitHub Actions by following the commands provided in the GitHub Actions settings.

#### **3. Writing the CI/CD Pipeline**
- Create a `.github/workflows` directory in the repository.
- Add a YAML file for the pipeline configuration.
- Define the following jobs:
  - **Compile**: Use Maven to build the application.
  - **Security Checks**: Install and run Trivy and GitLeaks to scan for vulnerabilities.
  - **Unit Testing**: Execute test cases using a testing framework.
  - **Build and Publish**: Build Docker images and upload artifacts using `actions/upload-artifact`.

#### **4. Integrating SonarQube**
- Add a SonarQube stage to analyze code quality.
- Configure secrets for SonarQube token and host URL in GitHub Actions.
- Install required dependencies like `unzip` to run the SonarQube scanner.

#### **5. Deploying to Kubernetes**
- Use Terraform to set up an EKS cluster.
- Install AWS CLI and configure access keys and region.
- Use `kubectl` to connect to the Kubernetes cluster and deploy the application using YAML manifests.

---

### **Why Use This Project?**
- **Automation**: Reduces manual effort by automating the CI/CD process.
- **Scalability**: Easily integrates with Kubernetes for scalable deployments.
- **Security**: Ensures secure code and container images with tools like Trivy and SonarQube.
- **Flexibility**: Supports multiple stages and tools, making it adaptable to various project requirements.
- **Cost-Effective**: Eliminates the need for maintaining Jenkins servers by leveraging GitHub-hosted or self-hosted runners.

---

### **Conclusion**
This project demonstrates the power of GitHub Actions in automating CI/CD workflows. By integrating tools like Trivy, SonarQube, Docker, and Kubernetes, it ensures a secure and efficient deployment process. The use of Terraform and AWS CLI further simplifies infrastructure management. This pipeline is ideal for teams looking to streamline their development and deployment processes while maintaining high standards of security and quality.

---------------------------------------will test it if required
>>>>>>> 2390b735d79421667cd689feab31c8dbd0f42927
# Technical Document: GitHub Actions CI/CD Pipeline for Kubernetes Deployment

This document outlines the implementation of a Continuous Integration and Continuous Delivery (CI/CD) pipeline using GitHub Actions to build, test, containerize, and deploy a Java application to a Kubernetes cluster.

<<<<<<< HEAD
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
=======
## 1. Introduction
This project demonstrates a comprehensive CI/CD workflow leveraging the capabilities of GitHub Actions. It automates the process of building a Java application, performing security and quality checks, running unit tests, containerizing it with Docker, and finally deploying it to a Kubernetes environment.

## 2. Key Technologies and Tools Used
- **GitHub Actions**: The workflow automation platform provided by GitHub. It enables the creation of custom workflows directly within the GitHub repository.
- **Git**: A distributed version control system used for managing the source code.
- **Maven**: A build automation tool primarily used for Java projects.
- **JDK (Java Development Kit)**: The development environment used to compile and run Java applications.
- **Trivy**: A comprehensive security scanner for vulnerabilities in container images, file systems, and Git repositories.
- **GitLeaks**: A tool for scanning Git repositories for secrets and sensitive data.
- **SonarQube**: A platform for continuous inspection of code quality to perform static code analysis.
- **Docker**: A platform for building, shipping, and running applications in containers.
- **Kubernetes**: A container orchestration platform for automating deployment, scaling, and1 management of containerized applications.
- **AWS CLI** (Amazon Web Services Command Line Interface): A command-line tool to interact with AWS services, used here to configure kubectl for the EKS cluster.
- **kubectl**: The command-line tool for interacting with Kubernetes clusters.
- **Terraform** (Mentioned): While not explicitly shown in the pipeline steps, Terraform is mentioned as the tool used to set up the EKS cluster.

>>>>>>> 2390b735d79421667cd689feab31c8dbd0f42927
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
<<<<<<< HEAD
This project demonstrates a robust and automated CI/CD pipeline using GitHub Actions. By integrating security scanning, code quality analysis, containerization, and Kubernetes deployment, it showcases best practices for modern software development and delivery. The step-by-step approach and the use of industry-standard tools make this a valuable example for anyone looking to automate their deployment workflows. The use of a self-hosted runner provides flexibility and control over the execution environment, while the integration with GitHub Secrets ensures the secure management of sensitive credentials.
=======
This project demonstrates a robust and automated CI/CD pipeline using GitHub Actions. By integrating security scanning, code quality analysis, containerization, and Kubernetes deployment, it showcases best practices for modern software development and delivery. The step-by-step approach and the use of industry-standard tools make this a valuable example for anyone looking to automate their deployment workflows. The use of a self-hosted runner provides flexibility and control over the execution environment, while the integration with GitHub Secrets ensures the secure management of sensitive credentials.

>>>>>>> 2390b735d79421667cd689feab31c8dbd0f42927


### Technical Project Document: GitHub Actions CI/CD Pipeline with Live Project

---

#### **Project Overview**
This document outlines the step-by-step process of setting up a CI/CD pipeline using GitHub Actions. The project demonstrates how to automate the build, test, and deployment of an application to Kubernetes using tools like Docker, Trivy, SonarQube, and Terraform. The project also highlights the integration of AWS CLI for managing cloud resources and Kubernetes clusters.

---

### **Key Points**
1. **GitHub Actions Overview**:
   - GitHub Actions is used as the CI/CD tool for this project.
   - It eliminates the need for setting up and maintaining Jenkins servers by providing managed runners.

2. **Pipeline Stages**:
   - **Compile**: Builds the application.
   - **Security Checks**: Scans for vulnerabilities using Trivy and GitLeaks.
   - **Unit Testing**: Executes test cases to ensure code quality.
   - **Build and Publish Docker Image**: Builds a Docker image and uploads it as an artifact.
   - **Deploy to Kubernetes**: Deploys the application to an EKS cluster using Terraform.

3. **Tools and Technologies Used**:
   - **GitHub Actions**: CI/CD automation.
   - **Docker**: Containerization of the application.
   - **Trivy**: Security scanning for vulnerabilities.
   - **GitLeaks**: Detects hardcoded secrets in the source code.
   - **SonarQube**: Code quality analysis.
   - **AWS CLI**: Manages AWS resources.
   - **Terraform**: Infrastructure as Code (IaC) for provisioning EKS clusters.
   - **Kubernetes**: Orchestrates containerized applications.

4. **Why Use This Project**:
   - Automates the software delivery process.
   - Ensures code quality and security through automated checks.
   - Simplifies deployment to Kubernetes clusters.
   - Demonstrates best practices for CI/CD pipelines.

5. **Takeaways**:
   - Understanding of GitHub Actions and its capabilities.
   - Hands-on experience with integrating security tools like Trivy and GitLeaks.
   - Knowledge of deploying applications to Kubernetes using Terraform.
   - Insights into managing AWS resources with AWS CLI.

---

### **Step-by-Step Process**

#### **1. Setting Up GitHub Actions**
   - Create a GitHub repository and initialize it.
   - Add a `.github/workflows` directory and create a YAML file for the pipeline.

#### **2. Adding a Virtual Machine as a Runner**
   - Use GitHub's shared runners or set up a self-hosted runner.
   - Configure the runner by following the commands provided in GitHub's settings.

#### **3. Writing the CI/CD Pipeline**
   - **Compile Stage**:
     - Use `actions/checkout` to clone the repository.
     - Set up the required environment (e.g., JDK 17 for Java projects).
     - Compile the application using build tools like Maven.
   - **Security Checks**:
     - Install and run Trivy to scan for vulnerabilities in Docker images.
     - Use GitLeaks to detect hardcoded secrets in the source code.
   - **Unit Testing**:
     - Execute test cases to validate the application.
   - **Build and Publish Docker Image**:
     - Build a Docker image using `docker build`.
     - Push the image to a container registry or upload it as an artifact.
   - **Deploy to Kubernetes**:
     - Use Terraform to provision an EKS cluster.
     - Deploy the application using Kubernetes manifests.

#### **4. Configuring AWS CLI**
   - Install AWS CLI on the runner.
   - Run `aws configure` to set up access keys and region.
   - Use AWS CLI to interact with the EKS cluster.

#### **5. Setting Up Terraform**
   - Write Terraform scripts to provision the EKS cluster.
   - Use `terraform apply` to create the infrastructure.

#### **6. Deploying to Kubernetes**
   - Use `kubectl` to apply Kubernetes manifests.
   - Verify the deployment by checking the status of pods and services.

---

### **Tools and Technologies Used**
- **GitHub Actions**: Automates the CI/CD pipeline.
- **Docker**: Builds and runs containerized applications.
- **Trivy**: Scans for vulnerabilities in Docker images.
- **GitLeaks**: Detects hardcoded secrets in the source code.
- **SonarQube**: Performs static code analysis.
- **AWS CLI**: Manages AWS resources.
- **Terraform**: Provisions infrastructure as code.
- **Kubernetes**: Deploys and manages containerized applications.

---

### **Why Use This Project**
- **Automation**: Reduces manual effort in building, testing, and deploying applications.
- **Security**: Ensures code and container security through automated scans.
- **Scalability**: Deploys applications to scalable Kubernetes clusters.
- **Best Practices**: Demonstrates industry-standard CI/CD practices.

---

### **Conclusion**
This project provides a comprehensive guide to setting up a CI/CD pipeline using GitHub Actions. By integrating tools like Docker, Trivy, SonarQube, and Terraform, it ensures a secure and efficient software delivery process. The use of AWS CLI and Kubernetes further demonstrates the deployment of applications to cloud-native environments. This project is a valuable resource for DevOps engineers looking to implement modern CI/CD pipelines.