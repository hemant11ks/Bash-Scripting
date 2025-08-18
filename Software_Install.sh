#!/bin/bash
# This script installs software packages.

# --- Script Configuration ---
# Define the software packages to install.  Modify this list as needed.
PACKAGES=(
  "git"
  "vim"
  "curl"
  "wget"
  # Add more packages here, one per line within the parentheses.
)

# Define any dependencies.  These will be installed *before* the main packages.
DEPENDENCIES=(
  "build-essential"  # Common build tools (gcc, make, etc.)
  "software-properties-common" # Needed for adding PPAs on Debian/Ubuntu
)

# --- Functions ---

# Function to install packages
install_packages() {
  echo "Installing packages..."
  # Use apt-get for Debian/Ubuntu, yum for CentOS/RHEL/Fedora, etc.
  # Adjust the command according to your Linux distribution.  Here's an example for Debian/Ubuntu:
  sudo apt-get update
  sudo apt-get install -y "${PACKAGES[@]}"

  # Example for CentOS/RHEL/Fedora:
  # sudo yum install -y "${PACKAGES[@]}"

  if [ $? -eq 0 ]; then
    echo "Packages installed successfully."
  else
    echo "Error installing packages.  Check the output above."
    exit 1 # Exit with an error code
  fi
}

# Function to install dependencies
install_dependencies() {
  echo "Installing dependencies..."
  # Similar to install_packages(), use the appropriate package manager for your distro.
  sudo apt-get install -y "${DEPENDENCIES[@]}" #Debian/Ubuntu example

  #sudo yum install -y "${DEPENDENCIES[@]}" #CentOS/RHEL/Fedora example

  if [ $? -eq 0 ]; then
    echo "Dependencies installed successfully."
  else
    echo "Error installing dependencies. Check output above."
    exit 1
  fi
}

# --- Main Script ---

# First, install dependencies
install_dependencies

# Then, install the main packages
install_packages

echo "Software installation complete."

exit 0 # Exit with a success code
