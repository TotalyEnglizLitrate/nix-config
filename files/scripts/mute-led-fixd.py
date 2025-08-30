import os
import select
import signal
import string
import subprocess
import sys
from pathlib import Path

DAEMON_NAME = "mute-led-fixd"
PIPE_PATH = Path(f"/var/run/{DAEMON_NAME}.pipe")
PID_FILE = Path(f"/var/run/{DAEMON_NAME}.pid")

COMMAND = "echo $((1 ^ $(cat /sys/class/leds/hda::micmute/brightness))) > /sys/class/leds/hda::micmute/brightness"


class Daemon:
    def __init__(self) -> None:
        self.ensure_su()
        self.running = True
        self._exit = 0

        if PID_FILE.exists():
            pid = PID_FILE.read_text().strip()
            if pid in string.digits:
                pid = int(pid)
                try:
                    os.kill(pid, 0)
                    print(f"Daemon already running with PID {pid}. Exiting.", file=sys.stderr)
                    self._exit = 1
                    self.cleanup()
                except ProcessLookupError:
                    print("Stale PID file found. Removing.", file=sys.stderr)
                    PID_FILE.unlink()

        PIPE_PATH.unlink(missing_ok=True)
        PIPE_PATH.parent.mkdir(exist_ok=True, mode=0o755)
        # mode: rw--w--w-
        os.mkfifo(PIPE_PATH, mode=0o622)
        os.chmod(PIPE_PATH, 0o622)

        signal.signal(signal.SIGINT, self.cleanup)
        signal.signal(signal.SIGTERM, self.cleanup)

        with open(PID_FILE, "w") as pid_file:
            pid_file.write(str(os.getpid()))

        self.listen()

    def ensure_su(self):
        if os.geteuid() != 0:
            print("This script must be run as root.", file=sys.stderr)
            sys.exit(1)

    def cleanup(self, _signum=None, _frame=None):
        self.running = False
        if PIPE_PATH.exists():
            PIPE_PATH.unlink()
        if PID_FILE.exists():
            PID_FILE.unlink()

        sys.exit(self._exit)

    def listen(self):
        pipe = os.open(PIPE_PATH, os.O_RDONLY | os.O_NONBLOCK)
        if pipe < 0:
            print("Failed to open pipe; exiting")
            self.cleanup()
        print(f"{DAEMON_NAME} is running with PID {os.getpid()}. Listening on {PIPE_PATH}...", file=sys.stderr)
        while self.running:
            try:
                readable, _, _ = select.select([pipe], [], [], 1.0)
                if readable and os.read(pipe, 1024):
                    subprocess.run(COMMAND, shell=True)
            except SystemExit:
                self.cleanup()
            except BlockingIOError:
                # wait for IO to be ready
                continue
            except Exception as e:
                print(f"Error: {e} ({type(e)})", file=sys.stderr)
                self.cleanup()


if __name__ == "__main__":
    Daemon()
