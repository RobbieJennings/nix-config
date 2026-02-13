{
  inputs,
  ...
}:
{
  flake.modules.homeManager.spotify =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        spotify.enable = lib.mkEnableOption "spotify music player";
      };

      config = lib.mkIf config.spotify.enable {
        services.flatpak.packages = [
          {
            appId = "com.spotify.Client";
            origin = "flathub";
          }
        ];
      };
    };
}
