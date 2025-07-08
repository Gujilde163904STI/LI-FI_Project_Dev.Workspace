import os
import subprocess
import getpass
import platform
from datetime import datetime

LOG_FILE = os.path.join(os.path.dirname(__file__), 'sync_workspace.log')


def log_action(action):
    username = getpass.getuser()
    hostname = platform.node()
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    with open(LOG_FILE, 'a') as f:
        f.write(f'[{timestamp}] {action} by {username} on {hostname}\n')


def run_git_command(args, cwd=None):
    try:
        result = subprocess.run(['git'] + args, cwd=cwd, check=True, capture_output=True, text=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f'Error running git {args}:', e.stderr)
        log_action(f'ERROR: git {args} failed: {e.stderr}')
        return None


def sync_push():
    log_action('Starting sync (push)')
    run_git_command(['add', '-A'])
    commit_msg = f'Auto-sync: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}'
    run_git_command(['commit', '-m', commit_msg])
    run_git_command(['push'])
    log_action('Pushed changes')


def sync_pull():
    log_action('Starting sync (pull)')
    run_git_command(['pull'])
    log_action('Pulled latest changes')


def main():
    print('Workspace Sync Tool')
    print('1. Push local changes to remote')
    print('2. Pull latest changes from remote')
    choice = input('Select action (1/2): ').strip()
    if choice == '1':
        sync_push()
        print('Push complete.')
    elif choice == '2':
        sync_pull()
        print('Pull complete.')
    else:
        print('Invalid choice.')


if __name__ == '__main__':
    main()

