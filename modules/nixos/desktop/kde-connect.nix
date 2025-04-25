{ config, lib, pkgs, inputs, ... }:

{
  options = {
    desktop.kde-connect.enable =
      lib.mkEnableOption "enables kde connect phone pairing app";
  };

  config =
    lib.mkIf config.desktop.kde-connect.enable { programs.kdeconnect.enable = true; };
}
