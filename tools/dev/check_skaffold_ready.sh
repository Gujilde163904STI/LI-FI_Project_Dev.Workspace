#!/usr/bin/env bash
set -e

check_skaffold_installed() {
  if ! command -v skaffold >/dev/null 2>&1; then
    echo "[ERROR] Skaffold not found. Install with:"
    echo "  curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64"
    echo "  sudo install skaffold /usr/local/bin/"
    return 1
  fi
  return 0
}

check_skaffold_running() {
  if ! systemctl --user is-active --quiet skaffold.service; then
    echo "[WARN] Skaffold service not running."
    read -p "Start it now? [Y/n]: " yn
    yn=${yn:-Y}
    if [[ "$yn" =~ ^[Yy]$ ]]; then
      systemctl --user start skaffold.service
      echo "Started skaffold.service"
    else
      return 1
    fi
  fi
  return 0
}

check_gcloud_config() {
  if ! command -v gcloud >/dev/null 2>&1; then
    echo "[ERROR] gcloud CLI not found. Install Google Cloud SDK first."
    return 1
  fi
  
  if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo "[ERROR] Not logged into gcloud. Run: gcloud auth login"
    return 1
  fi
  
  PROJECT=$(gcloud config get-value project 2>/dev/null)
  if [[ "$PROJECT" != "galahadd-lifi-dev" ]]; then
    echo "[WARN] Project is $PROJECT, expected galahadd-lifi-dev"
    read -p "Switch to galahadd-lifi-dev? [Y/n]: " yn
    yn=${yn:-Y}
    if [[ "$yn" =~ ^[Yy]$ ]]; then
      gcloud config set project galahadd-lifi-dev
      echo "Switched to galahadd-lifi-dev"
    else
      return 1
    fi
  fi
  return 0
}

main() {
  echo "[INFO] Checking Skaffold readiness..."
  
  if ! check_skaffold_installed; then
    exit 1
  fi
  
  if ! check_skaffold_running; then
    exit 1
  fi
  
  if ! check_gcloud_config; then
    exit 1
  fi
  
  echo "[SUCCESS] Skaffold is ready!"
}

main 