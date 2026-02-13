{
  inputs,
  ...
}:
{
  flake.modules.homeManager.kdenlive =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        kdenlive.enable = lib.mkEnableOption "kdenlive editing app";
      };

      config = lib.mkIf config.kdenlive.enable {
        services.flatpak.packages = [
          {
            appId = "org.kde.kdenlive";
            origin = "flathub";
          }
        ];
      };
    };
}
