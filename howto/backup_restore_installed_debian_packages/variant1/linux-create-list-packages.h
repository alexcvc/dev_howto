#!/bin/bash

# Backup your packages list
# Get a packages list
dpkg --get-selections > ~/Package.list

# Copy list of repositories
sudo cp /etc/apt/sources.list ~/sources.list

# Export repo keys
sudo apt-key exportall > ~/Repo.keys

