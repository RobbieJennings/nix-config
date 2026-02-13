{
  inputs,
  ...
}:
{
  flake.modules.homeManager.vlc =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        vlc.enable = lib.mkEnableOption "VLC media player";
      };

      config = lib.mkIf config.vlc.enable {
        services.flatpak.packages = [
          {
            appId = "org.videolan.VLC";
            origin = "flathub";
          }
        ];
      };
    };
}
