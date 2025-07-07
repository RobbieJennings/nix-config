{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    plasma-manager.input.enable = lib.mkEnableOption "plasma-manager input customisations";
  };

  config = lib.mkIf config.plasma-manager.input.enable {
    programs.plasma.input.keyboard.layouts = [ { layout = "ie"; } ];
  };
}
