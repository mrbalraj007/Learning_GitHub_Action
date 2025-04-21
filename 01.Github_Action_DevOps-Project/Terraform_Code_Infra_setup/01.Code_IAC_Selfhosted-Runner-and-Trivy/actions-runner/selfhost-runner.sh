#!/bin/bash

# Variables
RUNNER_VERSION="2.323.0"
RUNNER_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
RUNNER_DIR="actions-runner"
GITHUB_URL="https://github.com/mrbalraj007/GithubAction_DevOps_Projects" # define your git repo name
TOKEN="AMY4NLH5RYWBCJSBC5FSWG3IAWJKS"  # define your token value from runner
RUNNER_NAME="Custom_self_hosted_runner"
RUNNER_GROUP="Default"
WORK_FOLDER="_work"

# Create a folder for the runner
mkdir -p $RUNNER_DIR && cd $RUNNER_DIR

# Download the latest runner package
curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L $RUNNER_URL

# Optional: Validate the hash
# echo "0dbc9bf5a58620fc52cb6cc0448abcca964a8d74b5f39773b7afcad9ab691e19 actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" | shasum -a 256 -c

# Extract the installer
tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Create the runner and start the configuration experience
./config.sh --url $GITHUB_URL --token $TOKEN --name $RUNNER_NAME --runnergroup $RUNNER_GROUP --work $WORK_FOLDER --labels "self-hosted,Linux,X64" --unattended --replace

# Last step, run it!
./run.sh
