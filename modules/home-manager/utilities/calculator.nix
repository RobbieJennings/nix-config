{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    utilities.calculator.enable = lib.mkEnableOption "kalc calculator";
  };

  config = lib.mkIf config.utilities.calculator.enable {
    home.packages = [ pkgs.kdePackages.kalk ];
  };
}
