{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    editing.darktable.enable = lib.mkEnableOption "darktable editing app";
  };

  config = lib.mkIf config.editing.darktable.enable {
    services.flatpak.packages = [
      {
        appId = "org.darktable.Darktable";
        origin = "flathub";
      }
    ];
  };
}
