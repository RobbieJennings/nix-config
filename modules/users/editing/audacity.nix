{
  inputs,
  ...
}:
{
  flake.modules.homeManager.audacity =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        audacity.enable = lib.mkEnableOption "audacity editing app";
      };

      config = lib.mkIf config.audacity.enable {
        services.flatpak.packages = [
          {
            appId = "org.audacityteam.Audacity";
            origin = "flathub";
          }
        ];
      };
    };
}
