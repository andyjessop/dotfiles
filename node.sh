#!/usr/bin/env bash

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# The above command adds various variables to the bashrc, so we need to source it to avoid errors
source ~/.bashrc

# Insall the latest version of Node
nvm install node # "node" is an alias for the latest version
