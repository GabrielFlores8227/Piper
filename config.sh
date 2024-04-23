#!/bin/bash

##
## ENVS
##

# Define the path where the project will be cloned
export PROJECT_PATH="" 

# Define the git project URL
# For private repositories use: https://<git-username>:<git-token>@github.com/<repo-name>
export PROJECT_URL="" 

# Define the git project branch
export PROJECT_BRANCH="" 

# Define the average time in seconds that the project takes to run
export PROJECT_STARTUP_TIME=10 

##
## FUNCTIONS
##

# Insert all the commands needed to set up the project, including dependency installations and configurations
# Note that all commands inside this function will run in the directory passed in the variable "PROJECT_PATH"
BUILD_PROJECT() {
    # Example: yarn install && yarn build
}

# Insert all the commands needed to start the project after setup
# Note that all commands inside this function will run in the directory passed in the variable "PROJECT_PATH"
START_PROJECT() {
    # Example: yarn start
}

# Insert all the commands needed to stop the project after setup
# Note that all commands inside this function will run in the directory passed in the variable "PROJECT_PATH"
STOP_PROJECT() {
    # Example: fuser -k 3000/tcp && sleep 5
}
