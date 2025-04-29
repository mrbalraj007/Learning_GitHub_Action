#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting installation of required packages..."

# Make sure SSH is installed and running
echo "Ensuring SSH service is running..."
apt-get update -y
apt-get install -y openssh-server
systemctl enable ssh
systemctl start ssh

# Function to check if command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Install NVM (Node Version Manager)
echo "Installing NVM..."
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  # Load NVM without restarting shell
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
  echo "NVM already installed, sourcing it..."
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Install Node.js
echo "Installing Node.js v22..."
nvm install 22

# Verify Node.js installation
echo "Verifying Node.js installation..."
node_version=$(node -v)
echo "Node.js version: $node_version"
nvm_current=$(nvm current)
echo "NVM current: $nvm_current"

# Verify npm installation
npm_version=$(npm -v)
echo "npm version: $npm_version"

# Install aws-cost-cli
echo "Installing aws-cost-cli..."
if ! command_exists aws-cost; then
  npm install -g aws-cost-cli
else
  echo "aws-cost-cli already installed"
fi

# Install AWS CLI v2
echo "Installing AWS CLI v2..."
if ! command_exists aws || [[ $(aws --version) != *"aws-cli/2"* ]]; then
  echo "Downloading AWS CLI v2..."
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  
  echo "Extracting AWS CLI..."
  unzip -q awscliv2.zip
  
  echo "Installing AWS CLI..."
  sudo ./aws/install
  
  # Clean up downloaded files
  echo "Cleaning up installation files..."
  rm awscliv2.zip
  rm -rf aws
else
  echo "AWS CLI v2 already installed"
fi

# Verify AWS CLI installation
aws_version=$(aws --version)
echo "AWS CLI version: $aws_version"

echo "Installation complete!"


