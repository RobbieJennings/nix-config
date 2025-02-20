{ config, lib, pkgs, inputs, ... }:

{
  options = {
    kde-connect.enable = lib.mkEnableOption
      "opens firewall ports for kde connect phone pairing app";
  };

  config = lib.mkIf config.kde-connect.enable {
    programs.kdeconnect.enable = true;
    networking.firewall = rec {
      allowedTCPPortRanges = [{
        from = 1714;
        to = 1764;
      }];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
  };
}
