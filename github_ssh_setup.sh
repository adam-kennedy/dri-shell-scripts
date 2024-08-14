#!/bin/bash

# GitHub SSH Key Setup Script
# This script automates the process of generating an SSH key and setting it up for use with GitHub.
# It guides the user through key generation, adding the key to the ssh-agent, and provides
# instructions for adding the key to their GitHub account.

# Display script header
echo "=== GitHub SSH Key Setup ==="

# Step 1: Generate a new SSH key
echo "Step 1: Generating a new SSH key"
# Prompt the user for their email address
read -p "Enter your email address for the SSH key: " email
# Prompt the user for a key filename
read -p "Enter a filename for your SSH key (default: id_ed25519): " key_filename
key_filename=${key_filename:-id_ed25519}

# Check if the key already exists
if [ -f ~/.ssh/$key_filename ]; then
    echo "Warning: A key with the filename $key_filename already exists."
    echo "If you proceed, you'll be asked if you want to overwrite it."
    echo "If you don't want to overwrite, you can choose a different filename or exit."
    read -p "Do you want to proceed? (y/n): " proceed
    if [[ $proceed != [Yy]* ]]; then
        echo "Operation cancelled. Exiting script."
        exit 1
    fi
fi

# Generate an Ed25519 SSH key with the provided email as a comment
ssh-keygen -t ed25519 -f ~/.ssh/$key_filename -C "$email"
# Step 2: Start the ssh-agent in the background
echo "Step 2: Starting ssh-agent in the background"
# Start the ssh-agent and set necessary environment variables
eval "$(ssh-agent -s)"

# Step 3: Add the newly created SSH private key to the ssh-agent
echo "Step 3: Adding SSH key to ssh-agent"
# Add the private key to the ssh-agent
ssh-add ~/.ssh/id_ed25519

# Step 4: Provide instructions for copying the SSH public key
echo "Step 4: Instructions for copying the SSH public key"
echo "Please manually copy the contents of ~/.ssh/id_ed25519.pub"
echo "You can view the contents with: cat ~/.ssh/id_ed25519.pub"

# Provide step-by-step instructions for adding the key to GitHub
echo "=== Next Steps ==="
echo "1. Go to GitHub.com and sign in to your account"
echo "2. Click on your profile photo, then click 'Settings'"
echo "3. In the user settings sidebar, click 'SSH and GPG keys'"
echo "4. Click 'New SSH key' or 'Add SSH key'"
echo "5. In the 'Title' field, add a descriptive label for the new key"
echo "6. Paste your key into the 'Key' field"
echo "7. Click 'Add SSH key'"
echo "8. If prompted, confirm your GitHub password"

# Provide instructions for verifying the SSH connection
echo "=== Verification ==="
echo "To verify your SSH connection, run:"
echo "ssh -T git@github.com"
echo "If you see a message like 'Hi username! You've successfully authenticated...', you're all set!"

# Update the "Avoiding Passphrase Entry" section
echo "=== Avoiding Passphrase Entry ==="
echo "If you want to avoid entering your passphrase each time you use your SSH key, you can use ssh-agent to remember it for your session:"
echo ""
echo "1. Start the ssh-agent in the background:"
echo "   eval \"\$(ssh-agent -s)\""
echo ""
echo "2. Add your SSH private key to the ssh-agent:"
echo "   ssh-add ~/.ssh/$key_filename"
echo ""
echo "You'll need to enter your passphrase once, and then ssh-agent will remember it for the duration of your terminal session."
echo ""
echo "To make this permanent, you can add these lines to your ~/.bash_profile or ~/.bashrc file:"
echo ""
echo "if [ -z \"\$SSH_AUTH_SOCK\" ] ; then"
echo "    eval \"\$(ssh-agent -s)\""
echo "    ssh-add ~/.ssh/$key_filename"
echo "fi"
echo ""
echo "This will start the ssh-agent and add your key automatically when you open a new terminal."
echo "Note: Be cautious with this approach on shared systems, as it reduces the security provided by the passphrase."

# Note: This script does not automatically add the key to GitHub due to security considerations.
# The user must manually add the public key to their GitHub account as per the provided instructions.# New section: Information about avoiding passphrase entry each time
