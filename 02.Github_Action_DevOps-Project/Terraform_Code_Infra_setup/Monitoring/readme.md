I've created a GitHub Actions workflow file called install-monitoring-tools.yml in your specified Monitoring directory. This workflow will install the latest versions of Grafana and Prometheus on your self-hosted runner.

Key features of this workflow:

Triggered manually using the workflow_dispatch event
Optional inputs for specifying particular Grafana or Prometheus versions
Automatically fetches the latest versions if none are specified
Configures Prometheus as a data source in Grafana
Verifies that both services are running properly after installation
To use this workflow:

Commit this file to your repository, ensuring it's in the .github/workflows directory
Go to the "Actions" tab in your GitHub repository
Select the "Install Grafana and Prometheus" workflow
Click "Run workflow"
The workflow will then execute on your self-hosted runner, installing both monitoring tools without any manual intervention required. Both services will be configured and ready to use when the workflow completes.