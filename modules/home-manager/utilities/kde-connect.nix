{ config, lib, pkgs, inputs, ... }:

{
  options = {
    utilities.kde-connect.enable = lib.mkEnableOption "enables kde connect phone pairing app";
  };

  config = lib.mkIf config.utilities.kde-connect.enable {
    services.kdeconnect.enable = true;
    services.kdeconnect.package = pkgs.kdePackages.kdeconnect-kde;
  };
}
