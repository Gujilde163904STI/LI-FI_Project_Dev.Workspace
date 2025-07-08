#!/bin/bash

# Sync LI-FI_Project_Dev.Workspace from macOS to Windows using rsync over SSH

REMOTE_USER=PC-5
REMOTE_HOST=192.168.1.100
REMOTE_PATH='/C:/Users/PC-5/GALAHADD.DEV.PROJECTS/LI-FI_Project_Dev.Workspace'

# Run rsync with archive, verbose, compression, delete, and progress options
rsync -avz --delete --progress \
  /Users/djcarlogujilde/GALAHADD.DEV.PROJECTS/LI-FI_Project_Dev.Workspace/ \
  "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"

