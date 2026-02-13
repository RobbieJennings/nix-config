{
  inputs,
  ...
}:
{
  flake.modules.homeManager.krita =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        krita.enable = lib.mkEnableOption "krita editing app";
      };

      config = lib.mkIf config.krita.enable {
        services.flatpak.packages = [
          {
            appId = "org.kde.krita";
            origin = "flathub";
          }
        ];
      };
    };
}
