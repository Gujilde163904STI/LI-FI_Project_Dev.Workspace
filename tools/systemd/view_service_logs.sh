#!/usr/bin/env bash
set -e

SERVICES=("coder.service" "wayvnc.service" "skaffold.service")

if ! command -v journalctl >/dev/null 2>&1; then
  echo "journalctl not found. Cannot view logs."
  exit 1
fi

select_service() {
  if command -v fzf >/dev/null 2>&1; then
    echo "${SERVICES[@]}" | tr ' ' '\n' | fzf --prompt="Select service: "
  else
    echo "Select a service to view logs:"
    select svc in "${SERVICES[@]}"; do
      if [ -n "$svc" ]; then
        echo "$svc"
        return
      fi
    done
  fi
}

SERVICE=$(select_service)
if [ -z "$SERVICE" ]; then
  echo "No service selected."
  exit 1
fi

echo "Tailing logs for $SERVICE... (Press Ctrl+C to exit)"
journalctl --user -u "$SERVICE" -f 