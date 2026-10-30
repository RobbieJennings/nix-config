{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  just,
  libcosmicAppHook,
  nix-update-script,
}:

let
  commit = "7d2c3789c6f63178074311ec804a1f194a3e4e0a";
in
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-clipboard-manager";
  version = commit;

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "clipboard-manager";
    rev = commit;
    hash = "sha256-BmU7C40oq1mvkemZqKGNJfP7cA5wUkrtKAgqvT3WKug=";
  };

  cargoHash = "sha256-ABo4fAtFCaIyNukOUZqHpBhR0fANkb/h7lz755LyRpA=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  postPatch = ''
    substituteInPlace justfile \
      --replace-fail \
        'export CLIPBOARD_MANAGER_COMMIT := `git rev-parse --short HEAD`' \
        'export CLIPBOARD_MANAGER_COMMIT := "${builtins.substring 0 7 commit}"'
  '';

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-clipboard-manager"
  ];

  preCheck = ''
    export XDG_RUNTIME_DIR="$TMP"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/clipboard-manager";
    description = "Clipboard manager for the COSMIC Desktop Environment";
    mainProgram = "cosmic-ext-applet-clipboard-manager";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
