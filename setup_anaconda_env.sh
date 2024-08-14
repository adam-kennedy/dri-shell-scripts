#!/bin/bash

# anaconda Environment Setup and Management Script
# =============================================================================
# 
# This script provides an interactive interface for managing Anaconda
# environments. It allows users to:
#   1. List existing Conda environments
#   2. Select an existing environment
#   3. Create a new environment
#   4. Install specified packages in new environments
#
# Usage:
#   ./setup_anaconda_env.sh
#
# Requirements:
#   - Anaconda or Miniconda installation
#   - 'module' command available (typically on HPC systems)
#
# Author: Adam Kennedy
# Institution: Oregon State University
# Date: 2024-08-13
# Version: 1.0
# =============================================================================

# Exit immediately if a command exits with a non-zero status
set -e

# -----------------------------------------------------------------------------
# Function Definitions
# -----------------------------------------------------------------------------

# Function to list environments
list_environments() {
    echo "Existing Conda environments:"
    conda env list | grep -v "^#" | cut -d " " -f 1 | nl -w2 -s') '
}

# -----------------------------------------------------------------------------
# Main Script
# -----------------------------------------------------------------------------

echo "===== Anaconda Environment Setup and Management ====="

# 1. Load Anaconda module
echo "Loading Anaconda module..."
module load python/anaconda3-5.0.0.1

# 2. Print Python3 path
echo "Python3 path:"
which python3

# 3. Print Conda path
echo "Conda path:"
which conda

# Get existing environments
existing_envs=($(conda env list | grep -v "^#" | cut -d " " -f 1))

if [ ${#existing_envs[@]} -gt 0 ]; then
    echo "Existing environments found."
    list_environments
    echo "0) Create a new environment"
    read -p "Select an environment number or 0 to create a new one: " selection

    if [ $selection -eq 0 ]; then
        # Create new environment
        read -p "Enter the name for your new Conda environment: " env_name
        echo "Creating new Conda environment '$env_name'..."
        conda create -y -n $env_name
        echo "Installing required packages in '$env_name'..."
        conda install -y -n $env_name psutil py-cpuinfo numba pandas
    elif [ $selection -gt 0 ] && [ $selection -le ${#existing_envs[@]} ]; then
        # Select existing environment
        env_name=${existing_envs[$selection-1]}
        echo "Selected environment: $env_name"
    else
        echo "Invalid selection. Exiting."
        exit 1
    fi
else
    echo "No existing environments found."
    # Create new environment when none exist
    read -p "Enter the name for your new Conda environment: " env_name
    echo "Creating new Conda environment '$env_name'..."
    conda create -y -n $env_name
    echo "Installing required packages in '$env_name'..."
    conda install -y -n $env_name psutil py-cpuinfo numba pandas
fi

# -----------------------------------------------------------------------------
# Instructions for Environment Usage
# -----------------------------------------------------------------------------

echo "===== Environment Setup Complete ====="
echo "To activate this environment, run the following commands:"
echo "  source $(conda info --base)/etc/profile.d/conda.sh"
echo "  conda activate $env_name"

echo "To deactivate the environment when you're done, run:"
echo "  conda deactivate"

echo "To delete this environment if you no longer need it, run:"
echo "  conda env remove -n $env_name"

echo "===== Happy Computing! ====="
