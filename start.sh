#!/bin/bash
source config.sh

##
## ENVS
## 

CURRENT_DIRECTORY=$(pwd)

##
## FUNCTIONS
##

CLONE_REPO() {
    rm -rf "$REPO_PATH" && git clone -b "$REPO_BRANCH" "$REPO_URL" "$REPO_PATH"
}

CHECK_IF_REPO_IS_UP_TO_DATE() {
    cd "$REPO_PATH" 

    git fetch > /dev/null 2>&1
    
    git diff HEAD origin/$(git rev-parse --abbrev-ref HEAD) --quiet
    REPO_STATUS=$?

    cd "$CURRENT_DIRECTORY"

    return $REPO_STATUS
}

EXEC_BUILD_PROJECT() {
    cd "$REPO_PATH" 

    BUILD_PROJECT

    cd "$CURRENT_DIRECTORY"
}

EXEC_START_PROJECT() {
    cd "$REPO_PATH"

    (
        START_PROJECT 
    ) &

    sleep "$PROJECT_STARTUP_TIME"

    cd "$CURRENT_DIRECTORY"
}

EXEC_STOP_PROJECT() {
    cd "$REPO_PATH" 

    STOP_PROJECT

    cd "$CURRENT_DIRECTORY"
}

DISPLAY_CLONE_BUILD_START_PROJECT() {
    echo -e "\nℹ️  Initiating repository cloning..."

    CLONE_REPO 

    if [ $? -eq 0 ]; then
        echo -e "\n🟢 Repository cloned successfully"
    else
        echo -e "\n🔴 Failed to clone the repository. Exiting..."
        exit 1
    fi
    
    echo -e "\nℹ️  Initiating project build..."
    
    EXEC_BUILD_PROJECT 

    if [ $? -eq 0 ]; then
        echo -e "\n🟢 Project built successfully"
    else
        echo -e "\n🔴 Failed to build the project. Exiting..."
        exit 1
    fi

    echo -e "\nℹ️  Initiating project..."

    EXEC_START_PROJECT

    if [ $? -eq 0 ]; then
        echo -e "\n🟢 Project started successfully"
    else
        echo -e "\n🔴 Failed to start the project. Exiting..."
        exit 1
    fi
}

DISPLAY_STOP_CLONE_BUILD_START_PROJECT() {
    echo -e "\nℹ️  Stopping project..."

    EXEC_STOP_PROJECT

    if [ $? -eq 0 ]; then
        echo -e "\n🟢 Project stopped successfully"
    else
        echo -e "\n🔴 Failed to stop the project. Exiting..."
        exit 1
    fi

    DISPLAY_CLONE_BUILD_START_PROJECT   
}

##
## MAIN
##

DISPLAY_CLONE_BUILD_START_PROJECT

while true
do
    if ! CHECK_IF_REPO_IS_UP_TO_DATE; then
        DISPLAY_STOP_CLONE_BUILD_START_PROJECT
    fi

    sleep 500
done
