{ config, lib, pkgs, inputs, ... }:

{
  options = {
    utilities.vlc.enable = lib.mkEnableOption "enables VLC media player";
  };

  config = lib.mkIf config.utilities.vlc.enable {
    services.flatpak.packages = [{
      appId = "org.videolan.VLC";
      origin = "flathub";
    }];
  };
}
