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
          package = pkgs.vscodium;
          profiles.default = {
            extensions = with pkgs.vscode-extensions; [
              golang.go
              bbenoist.nix
              skellock.just
            ];
            userSettings = {
              terminal.integrated.fontFamily = "JetBrainsMono Nerd Font Mono";
            };
          };
        };
      };
    };
}
