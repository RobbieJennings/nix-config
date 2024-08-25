{ config, lib, pkgs, inputs, ... }:

{
  options = {
    web.ktorrent.enable = lib.mkEnableOption "enables ktorrent client";
  };

  config = lib.mkIf config.web.ktorrent.enable {
    services.flatpak.packages = [ { appId = "org.kde.ktorrent"; origin = "flathub"; } ];
  };
}
