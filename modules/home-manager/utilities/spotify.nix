{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    utilities.spotify.enable = lib.mkEnableOption "spotify music player";
  };

  config = lib.mkIf config.utilities.spotify.enable {
    services.flatpak.packages = [
      {
        appId = "com.spotify.Client";
        origin = "flathub";
      }
    ];
  };
}
