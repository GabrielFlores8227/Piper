<div align="center">
  <a href="https://www.gabriel-flores.dev/" target="_blank">
    <img src='https://github.com/GabrielFlores8227/GabrielFlores8227/blob/main/global-assets/Piper-Sync/piper-sync.png' height='90'>
  </a>
</div>

<h1 align="center">
  Piper Sync
</h1>

<p align="center">
  Piper Sync is the versatile bash script designed to effortlessly manage web applications, keeping a vigilant eye on a designated Git repository for any updates. 
  Seamlessly, it ensures your local repository stays synchronized, automatically integrating the latest features onto your server.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-1.0.0-blue" alt="version">
</p>

## 📝 About

Piper Sync is meticulously designed to streamline the synchronization between your local and remote repositories, ensuring the seamless operation of your web application on 
your server. With its straightforward functionality, Piper adeptly clones, builds, and executes your web application while guaranteeing continuous updates from your chosen Git 
repository branch. Operating with efficiency and diligence, Piper gracefully halts the application upon detecting updates. It then proceeds to clone the latest version from the 
repository, executes the necessary build processes, and seamlessly restarts the application, ensuring that you always have the freshest iteration running on your server.

## 🔨 Setup

To set up Piper Sync, navigate to the config.sh file. You'll need to define the following variables:

```bash
# Define the path where the repository will be cloned
export REPO_PATH="" 

# Define the git repository URL
# For private repositories use: https://<git-username>:<git-token>@github.com/<repo-name>
export REPO_URL="" 

# Define the git repository branch
export REPO_BRANCH="" 

# Define the average time in seconds that the project takes to run
export PROJECT_STARTUP_TIME=15 
```

Next, you'll need to set up the following functions:

```bash
# Insert all the commands needed to set up the project, including dependency installations and configurations
# Note that all commands inside this function will run in the directory passed in the variable "REPO_PATH"
BUILD_PROJECT() {
    # Example: yarn install && yarn build
}

# Insert all the commands needed to start the project after setup
# Note that all commands inside this function will run in the directory passed in the variable "REPO_PATH"
START_PROJECT() {
    # Example: yarn start
}

# Insert all the commands needed to stop the project after setup
# Note that all commands inside this function will run in the directory passed in the variable "REPO_PATH"
STOP_PROJECT() {
    # Example: fuser -k 3000/tcp
}
```

Pro Tip: For a seamless experience, configure a daemon to automatically start Piper Sync when your machine boots. Below are the configurations to 
set up the daemon (don't forget to enable the daemon by running: `systemctl enable`):

```service
[Unit]
Description=Pyper-Sync Service
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash /path/to/start.sh

[Install]
WantedBy=multi-user.target
```
