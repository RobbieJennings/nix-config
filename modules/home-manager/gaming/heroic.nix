{ config, lib, pkgs, inputs, ... }:

{
  options = {
    gaming.heroic.enable = lib.mkEnableOption "enables heroic games launcher";
  };

  config = lib.mkIf config.gaming.heroic.enable {
    services.flatpak.packages = [{
      appId = "com.heroicgameslauncher.hgl";
      origin = "flathub";
    }];
  };
}
