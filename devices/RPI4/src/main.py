import socket
import time
import threading
import sys
try:
    import RPi.GPIO as GPIO
except ImportError:
    GPIO = None  # For dev/testing on non-RPi

PHOTODIODE_PIN = 17  # BCM
LED_PIN = 15         # BCM (status LED)
TCP_PORT = 9000
UDP_PORT = 9001
HANDSHAKE_MSG = b'HELLO'
ACK_MSG = b'ACK'
RETRY_LIMIT = 3
HANDSHAKE_TIMEOUT = 2  # seconds
BIT_DURATION = 0.1    # 100ms per Manchester bit


def setup_gpio():
    if GPIO is None:
        print('[WARN] RPi.GPIO not available, running in simulation mode.')
        return
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(PHOTODIODE_PIN, GPIO.IN)
    GPIO.setup(LED_PIN, GPIO.OUT)
    GPIO.output(LED_PIN, GPIO.LOW)


def blink_led(times, fast=True):
    if GPIO is None:
        print(f'[SIM] LED blink x{times} (fast={fast})')
        return
    for _ in range(times):
        GPIO.output(LED_PIN, GPIO.HIGH)
        time.sleep(0.1 if fast else 0.5)
        GPIO.output(LED_PIN, GPIO.LOW)
        time.sleep(0.1)


def manchester_decode(pin, bit_count=8, timeout=2):
    """Decode a Manchester-encoded byte from GPIO input."""
    if GPIO is None:
        print('[SIM] Manchester decode (simulated)')
        return None
    start = time.time()
    bits = []
    while len(bits) < bit_count:
        t0 = time.time()
        while GPIO.input(pin) == 0:
            if time.time() - t0 > BIT_DURATION * 2:
                break
        t1 = time.time()
        if t1 - t0 > timeout:
            break
        # Sample at middle of bit window
        time.sleep(BIT_DURATION / 2)
        val = GPIO.input(pin)
        bits.append(val)
        time.sleep(BIT_DURATION / 2)
    # Manchester decode: 1=10, 0=01
    decoded = []
    for i in range(0, len(bits)-1, 2):
        if bits[i] == 1 and bits[i+1] == 0:
            decoded.append(1)
        elif bits[i] == 0 and bits[i+1] == 1:
            decoded.append(0)
    if len(decoded) < 8:
        return None
    byte = 0
    for b in decoded[:8]:
        byte = (byte << 1) | b
    return byte


def photodiode_handshake():
    print('[INFO] Waiting for photodiode handshake...')
    retries = 0
    while retries < RETRY_LIMIT:
        print(f'[INFO] Handshake attempt {retries+1}/{RETRY_LIMIT}')
        byte = manchester_decode(PHOTODIODE_PIN)
        if byte is not None and chr(byte) == 'H':
            print('[INFO] Received handshake H via light!')
            blink_led(2, fast=False)
            return True
        blink_led(1, fast=True)
        retries += 1
    print('[ERROR] Handshake failed after retries.')
    blink_led(5, fast=True)
    return False


def tcp_server():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(('', TCP_PORT))
    s.listen(1)
    print(f'[INFO] TCP server listening on port {TCP_PORT}')
    while True:
        conn, addr = s.accept()
        print(f'[INFO] Connection from {addr}')
        data = conn.recv(1024)
        if b'Hello from ESP8266' in data:
            print('[SUCCESS] Received: Hello from ESP8266')
            blink_led(3, fast=False)
        if data == HANDSHAKE_MSG:
            print('[INFO] Handshake received, sending ACK')
            conn.sendall(ACK_MSG)
            blink_led(1, fast=False)
        conn.close()


def print_ip():
    import netifaces
    try:
        ip = netifaces.ifaddresses('eth0')[netifaces.AF_INET][0]['addr']
    except Exception:
        ip = 'DHCP/Unknown'
    print(f'[INFO] RPi IP address: {ip}')


def main():
    print('[INFO] RPI4 LI-FI firmware starting...')
    setup_gpio()
    print_ip()
    if not photodiode_handshake():
        print('[ERROR] Could not complete handshake. Exiting.')
        return
    threading.Thread(target=tcp_server, daemon=True).start()
    while True:
        time.sleep(10)

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        if GPIO:
            GPIO.cleanup()
        print('\n[INFO] Exiting.') 