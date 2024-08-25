{ config, lib, pkgs, inputs, ... }:

{
  options = {
    gaming.steam.enable = lib.mkEnableOption "enables steam";
  };

  config = lib.mkIf config.gaming.steam.enable {
    services.flatpak.packages = [ { appId = "com.valvesoftware.Steam"; origin = "flathub"; } ];
  };
}
