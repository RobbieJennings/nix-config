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

      config.programs.vscodium = {
        enable = lib.mkIf config.vscode.enable true;
        package = pkgs.unstable.vscodium;
        profiles.default = {
          extensions = with pkgs.unstable.vscode-extensions; [
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
}
