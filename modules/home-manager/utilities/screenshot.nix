{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    utilities.screenshot.enable = lib.mkEnableOption "spectacle screenshot tool";
  };

  config = lib.mkIf config.utilities.screenshot.enable {
    home.packages = [ pkgs.kdePackages.spectacle ];
  };
}
