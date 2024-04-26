#!/bin/bash
cd "$(dirname "$0")"

source config.sh
source utils/utils.sh

##
## ENVS
##

DAEMON_DIRECTORY=$(pwd)
ORIGINAL_PROJECT_PATH=$PROJECT_PATH
UNSTABLE_PROJECT_SHA=""

##
## MAIN
##

TPL_CLONE_BUILD_START_PROJECT

if [ $? -ne 0 ]
then
    exit $?
fi

while true
do
    if ! TPL_CHECK_IF_PROJECT_IS_UP_TO_DATE 
    then
        PROJECT_PATH=$(mktemp -d)

        TPL_CLONE_PROJECT

        PROJECT_SHA=$(TPL_READ_PROJECT_SHA)

        if [ "$UNSTABLE_PROJECT_SHA" ==  "$PROJECT_SHA" ]
        then
            ECHO_FAILURE "New project version is not considered stable - $PROJECT_SHA"

            PROJECT_PATH=$ORIGINAL_PROJECT_PATH
        else
            TPL_STOP_BUILD_START_PROJECT

            PROCESS_STATUS=$?

            PROJECT_PATH=$ORIGINAL_PROJECT_PATH

            if [ $PROCESS_STATUS -eq 0 ]
            then
                ECHO_SUCCESS "New project version is stable - $PROJECT_SHA"

                UNSTABLE_PROJECT_SHA=""

                TPL_STOP_CLONE_BUILD_START_PROJECT
            else
                ECHO_FAILURE "New project version is not stable - $PROJECT_SHA"
                ECHO_SUCCESS "Returning to stable version"

                UNSTABLE_PROJECT_SHA=$PROJECT_SHA

                TPL_STOP_START_PROJECT
            fi
        fi
    fi

    sleep 5
done
