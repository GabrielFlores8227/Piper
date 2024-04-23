CLONE_PROJECT() {
      rm -rf "$USE_PROJECT_PATH" && git clone -b "$PROJECT_BRANCH" "$PROJECT_URL" "$USE_PROJECT_PATH"
}

TML_CLONE_PROJECT() {
      echo -e "\nℹ️  Starting project cloning - $USE_PROJECT_PATH"

      CLONE_PROJECT

      if [ $? -eq 0 ]
      then
            echo -e "\n🟢 Project cloned successfully"
            return 0
      else
            echo -e "\n🔴 Failed to clone the project"
            return 1
      fi
}

TPL_CLONE_PROJECT() {
      TML_CLONE_PROJECT

      return $?
}

READ_PROJECT_SHA() {
      cd "$USE_PROJECT_PATH" 

      local PROJECT_SHA=$(git rev-parse HEAD)

      cd "$INITIAL_DIRECTORY"

      echo "$PROJECT_SHA"
}

TML_READ_PROJECT_SHA() {
      echo "$(READ_PROJECT_SHA)"

}

TPL_READ_PROJECT_SHA() {
      echo "$(TML_READ_PROJECT_SHA)"
}

CHECK_IF_PROJECT_IS_UP_TO_DATE() {
      cd "$USE_PROJECT_PATH" 

      git fetch > /dev/null 2>&1
      
      git diff HEAD origin/$(git rev-parse --abbrev-ref HEAD) --quiet

      local PROJECT_STATUS=$?

      cd "$INITIAL_DIRECTORY"

      return $PROJECT_STATUS
}

TML_CHECK_IF_PROJECT_IS_UP_TO_DATE() {
      echo -e "\nℹ️  Checking project status - $USE_PROJECT_PATH"

      CHECK_IF_PROJECT_IS_UP_TO_DATE USE_PROJECT_PATH$

      if [ $? -eq 0 ]
      then
            echo -e "\n🟢 Local project is up to date"
            return 0
      else
            echo -e "\n🔴 Local project is not up to date"
            return 1
      fi
}

TPL_CHECK_IF_PROJECT_IS_UP_TO_DATE() {
      TML_CHECK_IF_PROJECT_IS_UP_TO_DATE

      return $?
}

TML_BUILD_PROJECT() {
      cd "$USE_PROJECT_PATH" 

      echo -e "\nℹ️  Building project - $USE_PROJECT_PATH"

      BUILD_PROJECT

      local PROCESS_STATUS=$?

      cd "$INITIAL_DIRECTORY"

      if [ $PROCESS_STATUS -eq 0 ]
      then
            echo -e "\n🟢 Project was built successfully"
            return 0
      else
            echo -e "\n🔴 Project could not be built"
            return 1
      fi
}

TML_START_PROJECT() {
      cd "$USE_PROJECT_PATH"

      echo -e "\nℹ️  Starting project - $USE_PROJECT_PATH"
      
      START_PROJECT &  
      local PID=$!
      
      sleep "$PROJECT_STARTUP_TIME"
      
      cd "$INITIAL_DIRECTORY"
      
      if kill -0 "$PID" 2>/dev/null; then
            echo -e "\n🟢 Project was started successfully"
            return 0
      else
            echo -e "\n🔴 Project could not be started"
            return 1
      fi
}

TML_STOP_PROJECT() {
      cd "$USE_PROJECT_PATH" 

      echo -e "\nℹ️  Stoping project - $USE_PROJECT_PATH"

      STOP_PROJECT

      local PROCESS_STATUS=$?

      cd "$INITIAL_DIRECTORY"

      sleep 5

      if [ $? -eq 0 ]
      then
            echo -e "\n🟢 Project was stopped successfully"
            return 0
      else
            echo -e "\n🔴 Project could not be stopped"
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