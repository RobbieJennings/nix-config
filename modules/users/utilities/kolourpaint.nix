{
  inputs,
  ...
}:
{
  flake.modules.homeManager.kolourpaint =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        kolourpaint.enable = lib.mkEnableOption "kolourpaint drawing app";
      };

      config = lib.mkIf config.kolourpaint.enable {
        services.flatpak.packages = [
          {
            appId = "org.kde.kolourpaint";
            origin = "flathub";
          }
        ];
      };
    };
}
