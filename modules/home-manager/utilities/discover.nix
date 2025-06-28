{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    utilities.discover.enable = lib.mkEnableOption "discover app store";
  };

  config = lib.mkIf config.utilities.discover.enable {
    home.packages = [ pkgs.kdePackages.discover ];
  };
}
