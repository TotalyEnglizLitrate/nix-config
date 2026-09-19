{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gettext,
  wrapGAppsHook4,
  desktop-file-utils,
  dbus,
  glib,
  gtk4,
  gtk4-layer-shell,
  json-glib,
  libevdev,
  ncurses,
  cairo,
  pango,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "seekey";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "Nakanomk";
    repo = "Seekey";
    rev = "5d0be1b444893cf4a1afea78ef20d0289e2dbce7";
    hash = "sha256-UgHKQVrZacYf8WJgTngN7P440pHPriAfKgw2d9a2rdM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    glib
    gtk4
    gtk4-layer-shell
    json-glib
    libevdev
    ncurses
    pango
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  nativeCheckInputs = [ desktop-file-utils dbus];
  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = {
    description = "Wayland keyboard visualizer with floating key bubbles";
    homepage = "https://github.com/Nakanomk/Seekey";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "seekey";
  };
})
