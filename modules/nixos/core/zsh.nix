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
      promptInit = lib.mkDefault "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      ohMyZsh.enable = lib.mkDefault true;
    };
  };
}
