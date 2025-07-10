{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    development.neovim.enable = lib.mkEnableOption "Neovim";
  };

  config = lib.mkIf config.development.neovim.enable {
    programs.neovim = {
      enable = true;
      plugins = [

      ];
    };
  };
}
