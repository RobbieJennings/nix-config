{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  just,
  libcosmicAppHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-clipboard-manager";
  version = "0.1.0-unstable-2025-03-05";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "clipboard-manager";
    rev = "fcab4b7b8d4934bc8bcdeec33a63628655fd7d57";
    hash = "sha256-TtYcr2BZCDI9FPHSO22pvWEV/BPiT74JTXhkdBBZrig=";
  };

  cargoHash = "sha256-OabpLa0mkpSOXIiJnNbnbV2QU8aTC6ybdwLNBpjm0aQ=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "env-dst"
    "${placeholder "out"}/etc/profile.d/cosmic-ext-applet-clipboard-manager.sh"
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
