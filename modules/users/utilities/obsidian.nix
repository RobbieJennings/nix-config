{
  inputs,
  ...
}:
{
  flake.modules.homeManager.obsidian =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        obsidian.enable = lib.mkEnableOption "obsidian markdown notes";
      };

      config = lib.mkIf config.obsidian.enable {
        services.flatpak.packages = [
          {
            appId = "md.obsidian.Obsidian";
            origin = "flathub";
          }
        ];
      };
    };
}
