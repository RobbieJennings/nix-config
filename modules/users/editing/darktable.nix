{
  inputs,
  ...
}:
{
  flake.modules.homeManager.darktable =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        darktable.enable = lib.mkEnableOption "darktable editing app";
      };

      config = lib.mkIf config.darktable.enable {
        services.flatpak.packages = [
          {
            appId = "org.darktable.Darktable";
            origin = "flathub";
          }
        ];
      };
    };
}
