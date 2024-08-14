#!/bin/bash

echo "=== GitHub SSH Key Setup ==="

# Step 1: Generate a new SSH key
echo "Step 1: Generating a new SSH key"
read -p "Enter your email address for the SSH key: " email
ssh-keygen -t ed25519 -C "$email"

# Step 2: Start the ssh-agent in the background
echo "Step 2: Starting ssh-agent in the background"
eval "$(ssh-agent -s)"

# Step 3: Add your SSH private key to the ssh-agent
echo "Step 3: Adding SSH key to ssh-agent"
ssh-add ~/.ssh/id_ed25519

# Step 4: Copy the SSH public key
echo "Step 4: Instructions for copying the SSH public key"
echo "Please manually copy the contents of ~/.ssh/id_ed25519.pub"
echo "You can view the contents with: cat ~/.ssh/id_ed25519.pub"

echo "=== Next Steps ==="
echo "1. Go to GitHub.com and sign in to your account"
echo "2. Click on your profile photo, then click 'Settings'"
echo "3. In the user settings sidebar, click 'SSH and GPG keys'"
echo "4. Click 'New SSH key' or 'Add SSH key'"
echo "5. In the 'Title' field, add a descriptive label for the new key"
echo "6. Paste your key into the 'Key' field"
echo "7. Click 'Add SSH key'"
echo "8. If prompted, confirm your GitHub password"

echo "=== Verification ==="
echo "To verify your SSH connection, run:"
echo "ssh -T git@github.com"
echo "If you see a message like 'Hi username! You've successfully authenticated...', you're all set!"
