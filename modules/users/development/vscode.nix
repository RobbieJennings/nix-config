{
  inputs,
  ...
}:
{
  flake.modules.homeManager.vscode =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        vscode.enable = lib.mkEnableOption "VS Code";
      };

      config = lib.mkIf config.vscode.enable {
        programs.vscode = {
          enable = true;
          profiles.default = {
            extensions = with pkgs.vscode-extensions; [
              golang.go
              bbenoist.nix
              skellock.just
              streetsidesoftware.code-spell-checker
            ];
            userSettings = {
              terminal.integrated.fontFamily = "JetBrainsMono Nerd Font Mono";
            };
          };
        };
      };
    };
}
