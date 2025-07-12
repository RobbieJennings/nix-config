{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    development.oh-my-posh.enable = lib.mkEnableOption "oh-my-posh";
  };

  config = lib.mkIf config.development.oh-my-posh.enable {
    programs.oh-my-posh = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      useTheme = "atomic";
    };
  };
}
