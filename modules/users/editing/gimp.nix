{
  inputs,
  ...
}:
{
  flake.modules.homeManager.gimp =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        gimp.enable = lib.mkEnableOption "gimp editing app";
      };

      config = lib.mkIf config.gimp.enable {
        services.flatpak.packages = [
          {
            appId = "org.gimp.GIMP";
            origin = "flathub";
          }
        ];
      };
    };
}
