#!/bin/bash
cd "$(dirname "$0")"

source config.env
source .modules/utils.sh

##
## ENVS
##

CURRENT_DIRECTORY=$(pwd)
ORIGINAL_PROJECT_PATH=$PROJECT_PATH

##
## MAIN
##

TPL_CLONE_BUILD_START_PROJECT

if [ $? -ne 0 ]
then
    exit 1
fi

while true
do
    sleep 20

    if TPL_CHECK_IF_PROJECT_IS_UP_TO_DATE 
    then
        continue
    fi

    PROJECT_PATH=$(mktemp -d)

    TPL_CLONE_PROJECT

    PROJECT_SHA=$(TPL_READ_PROJECT_SHA)

    if [ "$UNSTABLE_PROJECT_SHA" ==  "$PROJECT_SHA" ]
    then
        ECHO_FAILURE "New project version is not considered stable - $PROJECT_SHA"

        PROJECT_PATH=$ORIGINAL_PROJECT_PATH
    else
        ECHO_INFO "Starting new project version test"

        TPL_STOP_BUILD_START_PROJECT

        PROCESS_STATUS=$?

        PROJECT_PATH=$ORIGINAL_PROJECT_PATH

        if [ $PROCESS_STATUS -eq 0 ]
        then
            ECHO_SUCCESS "New project version is stable - $PROJECT_SHA"

            unset UNSTABLE_PROJECT_SHA

            TPL_STOP_CLONE_BUILD_START_PROJECT
        else
            ECHO_FAILURE "New project version is not stable - $PROJECT_SHA"
            ECHO_INFO "Returning to stable project version"

            UNSTABLE_PROJECT_SHA=$PROJECT_SHA

            TPL_STOP_START_PROJECT
        fi
    fi
done
