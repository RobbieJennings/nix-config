{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    development.vscode.enable = lib.mkEnableOption "VS Code";
  };

  config = lib.mkIf config.gaming.heroic.enable {
    programs.vscode = {
      enable = lib.mkDefault true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        skellock.just
      ];
    };
  };
}
