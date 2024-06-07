#!/bin/bash

# Update your existing list of packages
echo "Updating package list..."
sudo apt update -y

# Install prerequisite packages which let apt use packages over HTTPS
echo "Installing prerequisite packages..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add the GPG key for the official Docker repository to your system
echo "Adding Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add the Docker repository to APT sources
echo "Adding Docker repository..."
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# Update the package database with the Docker packages from the newly added repo
echo "Updating package list with Docker packages..."
sudo apt update -y

# Verify that Docker will be installed from the Docker repository
echo "Verifying Docker installation source..."
apt-cache policy docker-ce

# Install Docker
echo "Installing Docker..."
sudo apt install -y docker-ce

# Check if Docker is running
echo "Checking Docker status..."
sudo systemctl status docker --no-pager

# Install Git
echo "Installing Git..."
sudo apt install -y git

# Clone the repository
echo "Cloning the repository..."
git clone https://github.com/uzzalhcse/go-http-proxy.git

# Change directory to the cloned repository
cd go-http-proxy

# Build the Docker image
echo "Building the Docker image..."
sudo docker build -t go-http-proxy .

# Run the Docker container
echo "Running the Docker container..."
sudo docker run -d -p 3000:3000 go-http-proxy

echo "Script completed."