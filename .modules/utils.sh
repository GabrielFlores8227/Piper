##
## GLOBAL FUNCTIONS
##

ECHO_INFO() {
      echo -e "\n⚪  $1"
}

ECHO_WARNING() {
      echo -e "\n🟡  $1"
}

ECHO_SUCCESS() {
      echo -e "\n🟢  $1"
}

ECHO_FAILURE() {
      echo -e "\n🔴  $1"
}

##
## LOCAL FUNCTIONS
##

CLONE_PROJECT() {
      rm -rf "$PROJECT_PATH" && git clone -b "$PROJECT_BRANCH" "$PROJECT_URL" "$PROJECT_PATH"
}

TML_CLONE_PROJECT() {
      ECHO_INFO "Starting project cloning"

      CLONE_PROJECT

      if [ $? -eq 0 ]
      then
            ECHO_SUCCESS "Project cloned successfully"
            return 0
      else
            ECHO_FAILURE "Failed to clone the project"
            return 1
      fi
}

READ_PROJECT_SHA() {
      cd "$PROJECT_PATH" 

      echo "$(git rev-parse HEAD)"

      cd "$CURRENT_DIRECTORY"
}

TML_READ_PROJECT_SHA() {
      echo "$(READ_PROJECT_SHA)"

}

CHECK_IF_PROJECT_IS_UP_TO_DATE() {
      cd "$PROJECT_PATH" 

      git fetch > /dev/null 2>&1
      
      git diff HEAD origin/$(git rev-parse --abbrev-ref HEAD) --quiet

      local PROJECT_STATUS=$?

      cd "$CURRENT_DIRECTORY"

      return $PROJECT_STATUS
}

TML_CHECK_IF_PROJECT_IS_UP_TO_DATE() {
      ECHO_INFO "Checking project version"

      CHECK_IF_PROJECT_IS_UP_TO_DATE

      if [ $? -eq 0 ]
      then
            ECHO_SUCCESS "Local project is up to date"
            return 0
      else
            ECHO_WARNING "Local project is not up to date"
            return 1
      fi
}

BUILD_PROJECT() {
      eval "$BUILD_PROJECT_COMMAND"
}

TML_BUILD_PROJECT() {
      cd "$PROJECT_PATH" 

      ECHO_INFO "Building project"

      BUILD_PROJECT

      local PROCESS_STATUS=$?

      cd "$CURRENT_DIRECTORY"

      if [ $PROCESS_STATUS -eq 0 ]
      then
            ECHO_SUCCESS "Project was built successfully"
            return 0
      else
            ECHO_FAILURE "Project could not be built"
            return 1
      fi
}

START_PROJECT() {
      eval "$START_PROJECT_COMMAND"
}

TML_START_PROJECT() {
      cd "$PROJECT_PATH"

      ECHO_INFO "Starting project"
      
      START_PROJECT &  

      local PROCESS_PID=$!
      
      sleep "$PROJECT_STARTUP_TIME"
      
      cd "$CURRENT_DIRECTORY"
      
      if kill -0 "$PROCESS_PID" 2>/dev/null; then
            ECHO_SUCCESS "Project was started successfully"
            return 0
      else
            ECHO_FAILURE "Project could not be started"
            return 1
      fi
}

STOP_PROJECT() {
      eval "$STOP_PROJECT_COMMAND"
}

TML_STOP_PROJECT() {
      cd "$PROJECT_PATH" 

      ECHO_INFO "Stoping project"

      STOP_PROJECT

      local PROCESS_STATUS=$?

      cd "$CURRENT_DIRECTORY"

      sleep 5

      if [ $? -eq 0 ]
      then
            ECHO_SUCCESS "Project was stopped successfully"
            return 0
      else
            ECHO_FAILURE "Project could not be stopped"
            return 1
      fi
}

##
## GLOBAL FUNCTIONS
## 

TPL_CLONE_PROJECT() {
      TML_CLONE_PROJECT
}

TPL_READ_PROJECT_SHA() {
      echo "$(TML_READ_PROJECT_SHA)"
}

TPL_CHECK_IF_PROJECT_IS_UP_TO_DATE() {
      TML_CHECK_IF_PROJECT_IS_UP_TO_DATE
}

TPL_STOP_START_PROJECT() {
      TML_STOP_PROJECT \
            && TML_START_PROJECT
}

TPL_BUILD_START_PROJECT() {
      TML_BUILD_PROJECT \
            && TML_START_PROJECT
}

TPL_STOP_BUILD_START_PROJECT() {
      TML_STOP_PROJECT \
            && TPL_BUILD_START_PROJECT 
}

TPL_CLONE_BUILD_START_PROJECT() {
      TML_CLONE_PROJECT \
            && TPL_BUILD_START_PROJECT
}

TPL_STOP_CLONE_BUILD_START_PROJECT() {
      TML_STOP_PROJECT \
            && TPL_CLONE_BUILD_START_PROJECT
}