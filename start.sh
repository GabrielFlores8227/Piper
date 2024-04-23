#!/bin/bash
source config.sh
source utils/utils.sh

##
## ENVS
##

INITIAL_DIRECTORY=$(pwd)

USE_PROJECT_PATH=$PROJECT_PATH

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
        USE_PROJECT_PATH=$(mktemp -d)

        TPL_CLONE_PROJECT

        PROJECT_SHA=$(TPL_READ_PROJECT_SHA)

        if [ "$UNSTABLE_PROJECT_SHA" ==  "$PROJECT_SHA" ]
        then
            echo -e "\n🔴 New project version is not considered stable - $PROJECT_SHA"

            USE_PROJECT_PATH=$PROJECT_PATH
        else
            TPL_STOP_BUILD_START_PROJECT

            PROCESS_STATUS=$?

            USE_PROJECT_PATH=$PROJECT_PATH

            if [ $PROCESS_STATUS -eq 0 ]
            then
                echo -e "\n🟢 New project version is stable"

                UNSTABLE_PROJECT_SHA=""

                TPL_STOP_CLONE_BUILD_START_PROJECT
            else
                echo -e "\n🔴 New project version is not stable"      
                echo -e "\nℹ️  Returning to stable version"

                UNSTABLE_PROJECT_SHA=$PROJECT_SHA

                TPL_STOP_START_PROJECT
            fi
        fi
    fi

    sleep 500
done