{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    utilities.remoteDesktop.enable = lib.mkEnableOption "krdp remote desktop client";
  };

  config = lib.mkIf config.utilities.remoteDesktop.enable {
    home.packages = [ pkgs.kdePackages.krdp ];
  };
}
