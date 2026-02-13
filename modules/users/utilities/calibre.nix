{
  inputs,
  ...
}:
{
  flake.modules.homeManager.calibre =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        calibre.enable = lib.mkEnableOption "calibre ebook manager";
      };

      config = lib.mkIf config.calibre.enable {
        services.flatpak.packages = [
          {
            appId = "com.calibre_ebook.calibre";
            origin = "flathub";
          }
        ];
      };
    };
}
