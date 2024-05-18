<div align="center">
  <a href="https://www.gabriel-flores.dev/" target="_blank">
    <img src='https://github.com/GabrielFlores8227/GabrielFlores8227/blob/main/global-assets/Piper-Sync/piper-sync.png' height='90'>
  </a>
</div>

<h1 align="center">
  Piper Sync
</h1>

<p align="center">
  Piper Sync is the versatile bash script designed to effortlessly manage web applications, keeping a vigilant eye on a designated Git 
  repository for any updates. Seamlessly, it ensures your local repository stays synchronized, automatically integrating the latest 
  features onto your server.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-1.0.0-blue" alt="version">
</p>

## 📝 About

Piper Sync simplifies the synchronization between your local and remote repositories, ensuring smooth operation of your web application 
on your server. Its features include testing new project versions before deployment, efficiently cloning, building, and executing your 
web application from your chosen Git repository branch. Piper Sync gracefully halts the application upon detecting updates, clones the 
latest version from the repository, executes necessary build processes, and seamlessly restarts the application, keeping your server 
up-to-date with the latest changes.

## ✨ Features

- Clones the project from a GitHub repository.

- Checks if the project is up to date.

- Tests the new project version for stability.

- Handles unstable project versions by reverting to the last stable version.

## 🔧 How to Use

- ### Clone this repository to your local machine

  ```bash
  git clone https://github.com/GabrielFlores8227/Piper-Sync
  ```

- ### Set up your configuration in `config.env`:

  - `PROJECT_URL`: The URL of the GitHub repository.
  
  - `PROJECT_BRANCH`: The branch of the GitHub repository.
  
  - `PROJECT_PATH`: The local path where the project will be cloned (include the project folder name).
  
  - `PROJECT_STARTUP_TIME`: Average project startup time (in seconds).
  
  - `BUILD_PROJECT_COMMAND`: Command to build the project.
  
  - `START_PROJECT_COMMAND`: Command to start the project.
  
  - `STOP_PROJECT_COMMAND`: Command to stop the project.
    
- ### Execute the script:

  ```bash
  bash start.sh
  ```

## ⚡ Pipeline

Piper-Sync monitors the specified branch for updates every 5 minutes. Upon detecting changes, it clones the new repository version to the 
`/tmp` folder for stability testing. If the new branch version proves stable, Piper-Sync applies the changes to the project specified in the 
`config.env` file.

## 💡 Pro Tip

For a seamless experience, configure a daemon to automatically start Piper Sync when your machine boots. Below are the configurations to set up 
the daemon (don't forget to enable the daemon by running: `systemctl enable`):

- ### Daemon Configuration

  Create a file named piper-sync.service in /etc/systemd/system/ with the following content:
  
  ```servie
  [Unit]
  Description=Pyper-Sync Service
  After=network.target
  
  [Service]
  Type=simple
  ExecStart=/bin/bash /path/to/start.sh
  
  [Install]
  WantedBy=multi-user.target
  ```

  Then, enable the daemon:

  ```bash
  sudo systemctl enable piper-sync.service
  ```

  This will ensure that Piper Sync starts automatically when your machine boots.

## 📖 License

This script is licensed under the GNU General Public License, Version 3, 29 June 2007.

Feel free to use, modify, and distribute this script as per the terms of the license.

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://opensource.org/licenses/GPL-3.0)
