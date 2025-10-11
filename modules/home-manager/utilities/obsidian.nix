{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    utilities.obsidian.enable = lib.mkEnableOption "obsidian markdown notes";
  };

  config = lib.mkIf config.utilities.obsidian.enable {
    services.flatpak.packages = [
      {
        appId = "md.obsidian.Obsidian";
        origin = "flathub";
      }
    ];
  };
}
