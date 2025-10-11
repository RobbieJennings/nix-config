{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    utilities.obs.enable = lib.mkEnableOption "obs studio screen recorder";
  };

  config = lib.mkIf config.utilities.obs.enable {
    programs.obs-studio = {
      enable = true;
      plugins = [ ];
    };
  };
}
