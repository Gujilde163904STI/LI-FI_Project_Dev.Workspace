#!/bin/bash
# scripts/activate_venv.sh
# Quick activation for the workspace Python virtual environment
#
# Usage:
#   source scripts/activate_venv.sh   # Activate the venv
#   deactivate                       # Deactivate the venv

VENV_PATH="$(dirname "$0")/../venv"
if [ -d "$VENV_PATH" ]; then
  echo "[INFO] Activating workspace virtual environment..."
  # shellcheck disable=SC1090
  source "$VENV_PATH/bin/activate"
else
  echo "[ERROR] Virtual environment not found at $VENV_PATH. Run scripts/setup.sh first."
  exit 1
fi
