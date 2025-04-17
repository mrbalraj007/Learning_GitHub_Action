# Terraform GitHub Repository Creation

This project uses Terraform to create a new GitHub repository. It provides a simple and reusable way to manage your GitHub repositories through infrastructure as code.

## Prerequisites

- Terraform installed on your machine.
- A GitHub account.
- A GitHub personal access token with the necessary permissions to create repositories.

## Project Structure

```
terraform-github-repo
├── main.tf          # Main configuration for creating a GitHub repository
├── variables.tf     # Input variables for the Terraform configuration
├── outputs.tf       # Output values from the Terraform configuration
├── providers.tf     # Provider configuration for GitHub
└── README.md        # Project documentation
```

## Setup Instructions

1. **Clone the repository** (if applicable):
   ```bash
   git clone <repository-url>
   cd terraform-github-repo
   ```

2. **Set up your GitHub token**:
   Create a new GitHub personal access token with the `repo` scope at https://github.com/settings/tokens.
   
   Then set it as an environment variable (DO NOT commit your token to version control):
   
   ```bash
   # For Linux/macOS
   export GITHUB_TOKEN=your_github_token
   
   # For Windows Command Prompt
   set GITHUB_TOKEN=your_github_token
   
   # For Windows PowerShell
   $env:GITHUB_TOKEN="your_github_token"
   ```

3. **Update terraform.tfvars**:
   Modify the `terraform.tfvars` file with your desired repository settings:
   ```
   repository_name        = "your-repo-name"
   repository_description = "Your repository description"
   repository_private     = true  # or false for public repos
   github_owner           = "your-github-username"
   ```

4. **Initialize Terraform**:
   Run the following command to initialize the Terraform configuration:
   ```bash
   terraform init
   ```

5. **Plan the deployment**:
   Check what resources will be created:
   ```bash
   terraform plan
   ```

6. **Apply the configuration**:
   Create the GitHub repository by applying the configuration:
   ```bash
   terraform apply
   ```

7. **Check the outputs**:
   After the repository is created, you can view the outputs defined in `outputs.tf` to get the repository URL and ID.

## Cleanup

To delete the created resources, run:
```bash
terraform destroy
```

## License

This project is licensed under the MIT License.

=============
You are still getting `"Bad credentials"` from the GitHub API, which means your token is not valid for authentication. This is not a Terraform or code issue, but a problem with the token itself.

## What you must do:

1. **Generate a new Personal Access Token:**
   - Go to [GitHub Personal Access Tokens](https://github.com/settings/tokens).
   - Click **"Generate new token"** (classic).
   - Give it a name, select the `repo` scope (and `workflow` if you want to use Actions), and generate the token.
   - **Copy the token immediately** (you won't see it again).

2. **Set the new token as your environment variable:**
   - **Linux/macOS:**
     ```bash
     export GITHUB_TOKEN=your_new_token
     ```
   - **Windows PowerShell:**
     ```powershell
     $env:GITHUB_TOKEN="your_new_token"
     ```
   - **Windows CMD:**
     ```cmd
     set GITHUB_TOKEN=your_new_token
     ```

3. **Test with curl again:**
   ```bash
   curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user
   ```
   - You should see your GitHub user info in JSON, **not** "Bad credentials".

4. **Then run Terraform:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

---

**If you still get "Bad credentials":**
- Double-check you copied the token correctly (no spaces, no line breaks).
- Make sure you are not using an OAuth token or a fine-grained token with insufficient permissions.
- Make sure you are not using a GitHub App token (use a classic PAT).
- Make sure you are not using an expired or revoked token.

---

**No code changes are needed.**  
This is a GitHub authentication/token issue only.
````````````````