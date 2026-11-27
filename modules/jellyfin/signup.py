"""Tiny self-service sign-up page for Jellyfin.

Jellyfin has no built-in public registration, so this serves a form on
127.0.0.1 and creates the account through the admin API (POST /Users/New).
Only runs while custom.jellyfin.signup.enable is true (modules/jellyfin/host.nix).

Environment:
  JELLYFIN_URL      base URL of the local Jellyfin           (default http://127.0.0.1:8096)
  JELLYFIN_API_KEY  admin API key (Dashboard -> API Keys)    (required)
  INVITE_CODE       if set, the form requires this code      (optional, recommended)
  LISTEN_PORT       port to bind on 127.0.0.1                (default 8097)
"""

import hmac
import html
import json
import os
import re
import threading
import time
from typing import Any, override
import urllib.error
import urllib.parse
import urllib.request
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

JELLYFIN_URL = os.environ.get("JELLYFIN_URL", "http://127.0.0.1:8096").rstrip("/")
API_KEY = os.environ["JELLYFIN_API_KEY"]
INVITE_CODE = os.environ.get("INVITE_CODE", "")
PORT = int(os.environ.get("LISTEN_PORT", "8097"))

USERNAME_RE = re.compile(r"^[A-Za-z0-9._-]{3,32}$")
MIN_PASSWORD = 8
MAX_BODY = 4096

# global throttle: at most RATE_MAX attempts per RATE_WINDOW seconds, whoever sends them
RATE_MAX = 3
RATE_WINDOW = 60
_attempts: list[float] = []
_lock = threading.Lock()


def throttled():
    now = time.monotonic()
    with _lock:
        _attempts[:] = [t for t in _attempts if now - t < RATE_WINDOW]
        if len(_attempts) >= RATE_MAX:
            return True
        _attempts.append(now)
        return False


PAGE = """<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Jellyfin sign up</title>
<style>
  :root {{ color-scheme: light dark; }}
  body {{ font-family: system-ui, sans-serif; display: grid; place-items: center; min-height: 100vh; margin: 0; }}
  main {{ width: min(22rem, 90vw); }}
  label {{ display: block; margin-top: 1rem; }}
  input {{ width: 100%; box-sizing: border-box; padding: .5rem; margin-top: .25rem; font: inherit; }}
  button {{ margin-top: 1.5rem; padding: .6rem 1rem; font: inherit; width: 100%; }}
  .msg {{ margin-top: 1rem; padding: .6rem; border: 1px solid; border-radius: 4px; }}
</style></head>
<body><main>
<h1>Create an account</h1>
{message}
{form}
</main></body></html>
"""

FORM = """<form method="post" action="/signup" autocomplete="off">
<label>Username<input name="username" required minlength="3" maxlength="32" pattern="[A-Za-z0-9._-]+" autocapitalize="none"></label>
<label>Password<input name="password" type="password" required minlength="{min_pw}"></label>
<label>Confirm password<input name="confirm" type="password" required minlength="{min_pw}"></label>
{invite}
<button type="submit">Sign up</button>
</form>"""

INVITE_FIELD = '<label>Invite code<input name="invite" required></label>'


def render(message: str = "", ok: bool = False, show_form: bool = True):
    msg = ""
    if message:
        msg = '<p class="msg">{}</p>'.format(html.escape(message))
    form = ""
    if show_form:
        form = FORM.format(
            min_pw=MIN_PASSWORD,
            invite=INVITE_FIELD if INVITE_CODE else "",
        )
    elif ok:
        form = '<p><a href="/">Go to Jellyfin</a></p>'
    return PAGE.format(message=msg, form=form).encode()


def create_user(name: str, password: str):
    """Returns (ok, message)."""
    req = urllib.request.Request(
        JELLYFIN_URL + "/Users/New",
        data=json.dumps({"Name": name, "Password": password}).encode(),
        headers={
            "Content-Type": "application/json",
            "Authorization": 'MediaBrowser Token="{}"'.format(API_KEY),
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=10):
            return True, "Account created. You can sign in now."
    except urllib.error.HTTPError as e:
        if e.code == 400:
            return False, "That username is unavailable or invalid."
        print("jellyfin returned HTTP", e.code, flush=True)
    except (urllib.error.URLError, TimeoutError) as e:
        print("jellyfin unreachable:", e, flush=True)
    return False, "Something went wrong on the server. Try again later."


class Handler(BaseHTTPRequestHandler):
    server_version: str = "jellyfin-signup"

    def reply(self, status: int, body: bytes):
        self.send_response(status)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.send_header(
            "Content-Security-Policy",
            "default-src 'none'; style-src 'unsafe-inline'; form-action 'self'",
        )
        self.end_headers()
        _ = self.wfile.write(body)

    def do_GET(self):
        if self.path.split("?")[0] == "/signup":
            self.reply(200, render())
        else:
            self.reply(404, b"not found")

    def do_POST(self):
        if self.path.split("?")[0] != "/signup":
            return self.reply(404, b"not found")
        try:
            length = int(self.headers.get("Content-Length", "0"))
        except ValueError:
            length = -1
        if not 0 < length <= MAX_BODY:
            return self.reply(400, render("Bad request."))
        if throttled():
            return self.reply(429, render("Too many attempts, wait a minute."))

        form = urllib.parse.parse_qs(self.rfile.read(length).decode("utf-8", "replace"))

        def get(key: str) -> str:
            return form.get(key, [""])[0]

        username, password = get("username").strip(), get("password")

        if INVITE_CODE and not hmac.compare_digest(
            get("invite").encode(), INVITE_CODE.encode()
        ):
            return self.reply(403, render("Invalid invite code."))
        if not USERNAME_RE.fullmatch(username):
            return self.reply(
                400, render("Username must be 3-32 characters: letters, digits, . _ -")
            )
        if len(password) < MIN_PASSWORD:
            return self.reply(
                400,
                render("Password must be at least {} characters.".format(MIN_PASSWORD)),
            )
        if password != get("confirm"):
            return self.reply(400, render("Passwords do not match."))

        ok, message = create_user(username, password)
        self.reply(200 if ok else 400, render(message, ok=ok, show_form=not ok))

    @override
    def log_message(  # pyright: ignore[reportIncompatibleMethodOverride]
        self, fmt: str, *args: list[Any]  # pyright: ignore[reportExplicitAny]
    ):
        # never log request bodies; the access line is enough
        print(self.address_string(), fmt % args, flush=True)


if __name__ == "__main__":
    print("jellyfin-signup listening on 127.0.0.1:{}".format(PORT), flush=True)
    ThreadingHTTPServer(("127.0.0.1", PORT), Handler).serve_forever()
