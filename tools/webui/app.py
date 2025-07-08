#!/usr/bin/env python3
from flask import Flask, render_template_string, redirect, url_for, request, jsonify
import subprocess
import platform
import os

app = Flask(__name__)
SERVICES = ["coder.service", "wayvnc.service", "skaffold.service"]

TEMPLATE = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LI-FI Control Center</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 2em; }
        .service { margin-bottom: 1em; }
        .healthy { color: green; }
        .unhealthy { color: red; }
        button { margin-right: 1em; }
        .status { padding: 0.5em; margin: 0.5em 0; border-radius: 3px; }
        .ready { background: #d4edda; color: #155724; }
        .not-ready { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <h1>LI-FI Control Center</h1>
    
    <h2>Skaffold Status</h2>
    <div class="status {{ 'ready' if skaffold_ready else 'not-ready' }}">
        Skaffold: {{ 'Ready' if skaffold_ready else 'Not Ready' }}
        <form style="display:inline" method="post" action="/skaffold">
            <button name="action" value="check">Check</button>
            <button name="action" value="watch">Start Watch</button>
        </form>
    </div>
    
    <div class="status {{ 'ready' if gcloud_ready else 'not-ready' }}">
        GCloud: {{ 'Ready' if gcloud_ready else 'Not Ready' }}
        <form style="display:inline" method="post" action="/gcloud">
            <button name="action" value="login">Login</button>
            <button name="action" value="set-project">Set Project</button>
        </form>
    </div>
    
    <h2>Service Status</h2>
    {% for svc, status in statuses.items() %}
        <div class="service">
            <b>{{ svc }}</b>: <span class="{{ 'healthy' if status == 'active' else 'unhealthy' }}">{{ status }}</span>
            <form style="display:inline" method="post" action="/control">
                <input type="hidden" name="service" value="{{ svc }}">
                <button name="action" value="start">Start</button>
                <button name="action" value="stop">Stop</button>
                <button name="action" value="restart">Restart</button>
                <button name="action" value="logs">Logs</button>
            </form>
        </div>
    {% endfor %}
    
    <h2>Deploy Profiles</h2>
    <form method="post" action="/deploy">
        <button name="profile" value="local-dev">Local Dev</button>
        <button name="profile" value="gke-cloudbuild">GKE Cloud Build</button>
        <button name="profile" value="helm-deploy">Helm Deploy</button>
    </form>
    
    <h2>Tasks</h2>
    <form method="post" action="/task">
        <button name="task" value="flash">⚡ Flash ESP8266</button>
        <button name="task" value="deploy">📦 Deploy to RPi</button>
        <button name="task" value="boot">🟢 Boot</button>
    </form>
    
    <h2>Quick Links</h2>
    <a href="http://localhost:7080" target="_blank">Launch Coder</a> |
    <a href="vnc://localhost:5900" target="_blank">Launch WayVNC</a>
    
    <h2>System Alerts</h2>
    <form method="post" action="/alert">
        <input name="msg" placeholder="Message">
        <button type="submit">Send Alert</button>
    </form>
    
    <h2>QR Code (optional)</h2>
    <img src="/qrcode" alt="QR Code to access this dashboard">
</body>
</html>
"""


def get_service_status(service):
    try:
        result = subprocess.run(
            ["systemctl", "--user", "is-active", service],
            capture_output=True,
            text=True,
        )
        return result.stdout.strip()
    except Exception:
        return "error"


def get_logs(service):
    try:
        result = subprocess.run(
            ["journalctl", "--user", "-u", service, "-n", "40", "--no-pager"],
            capture_output=True,
            text=True,
        )
        return result.stdout
    except Exception:
        return "Log error"


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


def check_gcloud_ready():
    try:
        result = subprocess.run(
            ["gcloud", "auth", "list", "--filter=status:ACTIVE"],
            capture_output=True,
            text=True,
        )
        return "ACTIVE" in result.stdout
    except Exception:
        return False


def send_alert(msg):
    sys = platform.system()
    if sys == "Darwin":
        subprocess.run(["terminal-notifier", "-message", msg])
    elif sys == "Linux":
        subprocess.run(["notify-send", msg])
    elif sys == "Windows":
        subprocess.run(
            [
                "powershell",
                "-Command",
                f"[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null; $template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText01); $template.GetElementsByTagName('text')[0].AppendChild($template.CreateTextNode('{msg}')); $toast = [Windows.UI.Notifications.ToastNotification]::new($template); [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('LI-FI').Show($toast)",
            ]
        )


@app.route("/", methods=["GET", "POST"])
def index():
    statuses = {svc: get_service_status(svc) for svc in SERVICES}
    skaffold_ready = check_skaffold_ready()
    gcloud_ready = check_gcloud_ready()
    return render_template_string(
        TEMPLATE,
        statuses=statuses,
        skaffold_ready=skaffold_ready,
        gcloud_ready=gcloud_ready,
    )


@app.route("/control", methods=["POST"])
def control():
    svc = request.form["service"]
    action = request.form["action"]
    if action == "logs":
        logs = get_logs(svc)
        return f"<pre>{logs}</pre><a href='/'>Back</a>"
    else:
        subprocess.run(["systemctl", "--user", action, svc])
        return redirect(url_for("index"))


@app.route("/skaffold", methods=["POST"])
def skaffold():
    action = request.form["action"]
    if action == "check":
        if check_skaffold_ready():
            send_alert("Skaffold is ready!")
        else:
            send_alert("Skaffold is not ready")
    elif action == "watch":
        subprocess.Popen(["skaffold", "dev", "--watch", "--rpc-http-port", "8081"])
        send_alert("Started Skaffold watch mode")
    return redirect(url_for("index"))


@app.route("/gcloud", methods=["POST"])
def gcloud():
    action = request.form["action"]
    if action == "login":
        subprocess.run(["gcloud", "auth", "login"])
    elif action == "set-project":
        subprocess.run(["gcloud", "config", "set", "project", "galahadd-lifi-dev"])
    return redirect(url_for("index"))


@app.route("/deploy", methods=["POST"])
def deploy():
    profile = request.form["profile"]
    subprocess.run(["skaffold", "deploy", "--profile", profile])
    send_alert(f"Deployed with profile: {profile}")
    return redirect(url_for("index"))


@app.route("/task", methods=["POST"])
def task():
    task = request.form["task"]
    if task == "flash":
        os.system("../flash_all.sh")
    elif task == "deploy":
        os.system("skaffold deploy")
    elif task == "boot":
        os.system("./boot.sh")
    return redirect(url_for("index"))


@app.route("/alert", methods=["POST"])
def alert():
    msg = request.form["msg"]
    send_alert(msg)
    return redirect(url_for("index"))


@app.route("/qrcode")
def qrcode():
    try:
        import qrcode
        from io import BytesIO
        from flask import send_file

        img = qrcode.make("http://localhost:5050")
        buf = BytesIO()
        img.save(buf, format="PNG")
        buf.seek(0)
        return send_file(buf, mimetype="image/png")
    except ImportError:
        return "qrcode module not installed"


if __name__ == "__main__":
    app.run(port=5050, debug=False)
