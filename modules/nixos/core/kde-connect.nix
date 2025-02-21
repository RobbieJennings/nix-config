{ config, lib, pkgs, inputs, ... }:

{
  options = {
    kde-connect.enable = lib.mkEnableOption
      "enables kde connect phone pairing app";
  };

  config = lib.mkIf config.kde-connect.enable {
    programs.kdeconnect.enable = true;
  };
}
