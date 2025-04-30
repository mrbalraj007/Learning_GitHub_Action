#!/bin/bash

# Ensure we're running updates with sudo
sudo apt-get update -y
sudo apt-get install unzip curl -y 

# Download and install nvm (as regular user, no sudo needed):
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Set up NVM environment variables for the current session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 

# Source nvm without restarting the shell
source "$HOME/.nvm/nvm.sh"

# Make sure NVM is loaded in bash profiles for future logins
if ! grep -q "NVM_DIR" "$HOME/.bashrc"; then
  echo 'export NVM_DIR="$HOME/.nvm"' >> "$HOME/.bashrc"
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> "$HOME/.bashrc"
  echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> "$HOME/.bashrc"
fi

# Also add NVM to .profile to ensure it's loaded in non-interactive shells
if ! grep -q "NVM_DIR" "$HOME/.profile"; then
  echo 'export NVM_DIR="$HOME/.nvm"' >> "$HOME/.profile"
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> "$HOME/.profile"
fi

# Download and install Node.js (as regular user, no sudo needed):
nvm install 22

# Set default Node version
nvm alias default 22

# Verify the Node.js version:
node -v # Should print "v22.15.0".
nvm current # Should print "v22.15.0".

# Verify npm version:
npm -v # Should print "10.9.2".

# Update npm (as regular user, no sudo needed):
npm install -g npm@11.3.0

# Add npm global bin to PATH permanently
NPM_GLOBAL_BIN="$HOME/.nvm/versions/node/$(node -v | cut -c 2-)/bin"
if ! grep -q "$NPM_GLOBAL_BIN" "$HOME/.bashrc"; then
  echo "export PATH=\"$NPM_GLOBAL_BIN:\$PATH\"" >> "$HOME/.bashrc"
fi

# Install aws-cost-cli globally (as regular user, no sudo needed):
npm install -g aws-cost-cli

# Create symbolic link to make aws-cost available for all users
AWS_COST_PATH=$(which aws-cost)
sudo ln -sf "$AWS_COST_PATH" /usr/local/bin/aws-cost

# Install AWS CLI (downloading as regular user, installing with sudo)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$HOME/awscliv2.zip"
sudo apt install unzip -y
unzip "$HOME/awscliv2.zip" -d "$HOME"
sudo "$HOME/aws/install"

# Configure AWS CLI (as regular user, no sudo needed)
echo "AWS configure............."
aws configure set aws_access_key_id ${aws_access_key_id}
aws configure set aws_secret_access_key ${aws_secret_access_key}
aws configure set default.region ${aws_default_region}
aws configure set default.output json

# Verify AWS configuration
echo "Verify AWS configuration"
aws sts get-caller-identity

# Create a simple script that sources the environment and runs aws-cost
cat > "$HOME/run-aws-cost.sh" << 'EOF'
#!/bin/bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
PATH="$HOME/.nvm/versions/node/$(node -v | cut -c 2-)/bin:$PATH"
aws-cost "$@"
EOF
chmod +x "$HOME/run-aws-cost.sh"

# Also create a system-wide script
sudo bash -c 'cat > /usr/local/bin/aws-cost-run << EOF
#!/bin/bash
sudo -u ubuntu bash -c "export NVM_DIR=/home/ubuntu/.nvm && [ -s \$NVM_DIR/nvm.sh ] && . \$NVM_DIR/nvm.sh && /home/ubuntu/run-aws-cost.sh \"\$@\""
EOF'
sudo chmod +x /usr/local/bin/aws-cost-run

echo "To run aws-cost in a new session, you may need to: source ~/.bashrc && aws-cost"
echo "Or run: ~/run-aws-cost.sh"

# Run aws-cost commands (source environment first to ensure it's available)
echo "Running aws-cost command..."
source ~/.bashrc && aws-cost

# AWS-Cost version details
echo "AWS-Cost version details"
source ~/.bashrc && aws-cost --version  

# Run aws-cost commands
source ~/.bashrc && aws-cost --help

