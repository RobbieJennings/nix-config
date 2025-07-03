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

  config = lib.mkIf config.development.vscode.enable {
    programs.vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        skellock.just
      ];
    };
  };
}
