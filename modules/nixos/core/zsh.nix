{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    zsh.enable = lib.mkEnableOption "zsh";
  };

  config = lib.mkIf config.zsh.enable {
    users.defaultUserShell = pkgs.zsh;
    programs.zsh = {
      enable = true;
      ohMyZsh.enable = lib.mkDefault true;
    };
  };
}
