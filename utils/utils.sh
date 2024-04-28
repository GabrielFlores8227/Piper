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

CLONE_PROJECT() {
      rm -rf "$PROJECT_PATH" && git clone -b "$PROJECT_BRANCH" "$PROJECT_URL" "$PROJECT_PATH"
}

TML_CLONE_PROJECT() {
      ECHO_INFO "Starting project cloning - $PROJECT_PATH"

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

TPL_CLONE_PROJECT() {
      TML_CLONE_PROJECT

      return $?
}

READ_PROJECT_SHA() {
      cd "$PROJECT_PATH" 

      local PROJECT_SHA=$(git rev-parse HEAD)

      cd "$DAEMON_DIRECTORY"

      echo "$PROJECT_SHA"
}

TML_READ_PROJECT_SHA() {
      echo "$(READ_PROJECT_SHA)"

}

TPL_READ_PROJECT_SHA() {
      echo "$(TML_READ_PROJECT_SHA)"
}

CHECK_IF_PROJECT_IS_UP_TO_DATE() {
      cd "$PROJECT_PATH" 

      git fetch > /dev/null 2>&1
      
      git diff HEAD origin/$(git rev-parse --abbrev-ref HEAD) --quiet

      local PROJECT_STATUS=$?

      cd "$DAEMON_DIRECTORY"

      return $PROJECT_STATUS
}

TML_CHECK_IF_PROJECT_IS_UP_TO_DATE() {
      ECHO_INFO "Checking project status - $PROJECT_PATH"

      CHECK_IF_PROJECT_IS_UP_TO_DATE USE_PROJECT_PATH$

      if [ $? -eq 0 ]
      then
            ECHO_SUCCESS "Local project is up to date"
            return 0
      else
            ECHO_WARNING "Local project is not up to date"
            return 1
      fi
}

TPL_CHECK_IF_PROJECT_IS_UP_TO_DATE() {
      TML_CHECK_IF_PROJECT_IS_UP_TO_DATE

      return $?
}

TML_BUILD_PROJECT() {
      cd "$PROJECT_PATH" 

      ECHO_INFO "Building project - $PROJECT_PATH"

      BUILD_PROJECT

      local PROCESS_STATUS=$?

      cd "$DAEMON_DIRECTORY"

      if [ $PROCESS_STATUS -eq 0 ]
      then
            ECHO_SUCCESS "Project was built successfully"
            return 0
      else
            ECHO_FAILURE "Project could not be built"
            return 1
      fi
}

TML_START_PROJECT() {
      cd "$PROJECT_PATH"

      ECHO_INFO "Starting project - $PROJECT_PATH"
      
      START_PROJECT &  

      local PROCESS_PID=$!
      
      sleep "$PROJECT_STARTUP_TIME"
      
      cd "$DAEMON_DIRECTORY"
      
      if kill -0 "$PROCESS_PID" 2>/dev/null; then
            ECHO_SUCCESS "Project was started successfully"
            return 0
      else
            ECHO_FAILURE "Project could not be started"
            return 1
      fi
}

TML_STOP_PROJECT() {
      cd "$PROJECT_PATH" 

      ECHO_INFO "Stoping project - $PROJECT_PATH"

      STOP_PROJECT

      local PROCESS_STATUS=$?

      cd "$DAEMON_DIRECTORY"

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

TPL_STOP_START_PROJECT() {
      TML_STOP_PROJECT \
            && TML_START_PROJECT

      return $?
}

TPL_BUILD_START_PROJECT() {
      TML_BUILD_PROJECT \
            && TML_START_PROJECT
      
      return $?
}

TPL_STOP_BUILD_START_PROJECT() {
      TML_STOP_PROJECT \
            && TPL_BUILD_START_PROJECT 

      return $?
}

TPL_CLONE_BUILD_START_PROJECT() {
      TML_CLONE_PROJECT \
            && TPL_BUILD_START_PROJECT
      
      return $?
}

TPL_STOP_CLONE_BUILD_START_PROJECT() {
      TML_STOP_PROJECT \
            && TPL_CLONE_BUILD_START_PROJECT

      return $?
}
