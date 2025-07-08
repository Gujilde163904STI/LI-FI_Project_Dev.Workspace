#!/usr/bin/env python3
import os
import subprocess
import sys
import time
import threading
from rich.console import Console
from rich.table import Table
from rich.prompt import Prompt
from rich.panel import Panel
from rich import box

SERVICES = ["coder.service", "wayvnc.service", "skaffold.service"]
ACTIONS = ["Start", "Stop", "Restart", "View Logs"]
SCRIPTS = {
    "Flash All": "../flash_all.sh",
    "Deploy": "skaffold deploy",
    "Boot": "./boot.sh",
}
WATCH_PATHS = ["ESP8266/src/", "RPI3/src/", "RPI4/src/"]

console = Console()


def get_service_status(service):
    try:
        result = subprocess.run(
            ["systemctl", "--user", "is-active", service],
            capture_output=True,
            text=True,
        )
        status = result.stdout.strip()
        return status
    except Exception as e:
        return f"Error: {e}"


def check_skaffold_ready():
    try:
        result = subprocess.run(
            ["bash", "../tools/dev/check_skaffold_ready.sh"],
            capture_output=True,
            text=True,
        )
        return result.returncode == 0
    except Exception:
        return False


def start_skaffold_watch():
    try:
        subprocess.Popen(["skaffold", "dev", "--watch", "--rpc-http-port", "8081"])
        console.print("[green]Started Skaffold watch mode[/green]")
    except Exception as e:
        console.print(f"[red]Failed to start Skaffold: {e}[/red]")


def monitor_file_changes():
    """Monitor source directories for changes and restart Skaffold if needed"""
    while True:
        for path in WATCH_PATHS:
            if os.path.exists(path):
                # Simple file change detection (could be enhanced with watchdog)
                pass
        time.sleep(5)


def show_services():
    table = Table(title="LI-FI Systemd Services", box=box.SIMPLE)
    table.add_column("Service")
    table.add_column("Status")
    for svc in SERVICES:
        status = get_service_status(svc)
        table.add_row(svc, status)
    console.print(table)


def control_service(service, action):
    try:
        subprocess.run(["systemctl", "--user", action.lower(), service])
        console.print(f"[green]{action}ed {service}[/green]")
    except Exception as e:
        console.print(f"[red]Failed to {action} {service}: {e}[/red]")


def view_logs(service):
    os.system(f"journalctl --user -u {service} -n 40 --no-pager | less")


def show_menu():
    while True:
        console.clear()
        show_services()

        # Skaffold status
        skaffold_ready = check_skaffold_ready()
        console.print(
            f"\n[bold]Skaffold Status:[/bold] {'[green]Ready[/green]' if skaffold_ready else '[red]Not Ready[/red]'}"
        )

        console.print("\n[bold]Actions:[/bold]")
        for idx, svc in enumerate(SERVICES, 1):
            console.print(f"{idx}. Control {svc}")
        offset = len(SERVICES)
        for i, script in enumerate(SCRIPTS, 1):
            console.print(f"{offset + i}. Run {script}")
        console.print(f"{offset + len(SCRIPTS) + 1}. Start Skaffold Watch")
        console.print(f"{offset + len(SCRIPTS) + 2}. Check Skaffold Ready")
        console.print(f"{offset + len(SCRIPTS) + 3}. Exit")

        choice = Prompt.ask("Select option", default="1")
        try:
            choice = int(choice)
        except ValueError:
            continue

        if 1 <= choice <= len(SERVICES):
            svc = SERVICES[choice - 1]
            action = Prompt.ask(
                f"Action for {svc}",
                choices=[a.lower() for a in ACTIONS],
                default="restart",
            )
            if action == "view logs":
                view_logs(svc)
            else:
                control_service(svc, action.capitalize())
        elif len(SERVICES) < choice <= offset + len(SCRIPTS):
            script = list(SCRIPTS.values())[choice - offset - 1]
            os.system(script)
            input("Press Enter to continue...")
        elif choice == offset + len(SCRIPTS) + 1:
            start_skaffold_watch()
        elif choice == offset + len(SCRIPTS) + 2:
            if check_skaffold_ready():
                console.print("[green]Skaffold is ready![/green]")
            else:
                console.print(
                    "[red]Skaffold is not ready. Run check_skaffold_ready.sh[/red]"
                )
            input("Press Enter to continue...")
        elif choice == offset + len(SCRIPTS) + 3:
            break
        else:
            continue


if __name__ == "__main__":
    try:
        show_menu()
    except KeyboardInterrupt:
        console.print("\n[bold red]Exiting...[/bold red]")
        sys.exit(0)
