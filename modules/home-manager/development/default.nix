{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./vscode.nix
    ./neovim.nix
    ./oh-my-posh.nix
  ];

  options = {
    development.enable = lib.mkEnableOption "all development tools";
  };

  config = lib.mkIf config.development.enable {
    development = {
      vscode.enable = lib.mkDefault true;
      neovim.enable = lib.mkDefault true;
      oh-my-posh.enable = lib.mkDefault true;
    };
  };
}
