{ config, lib, pkgs, inputs, ... }:

{
  options = {
    gaming.lutris.enable = lib.mkEnableOption "enables lutris games launcher";
  };

  config = lib.mkIf config.gaming.lutris.enable {
    services.flatpak.packages = [{
      appId = "net.lutris.Lutris";
      origin = "flathub";
    }];
  };
}
