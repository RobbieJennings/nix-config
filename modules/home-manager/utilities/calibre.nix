{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    utilities.calibre.enable = lib.mkEnableOption "calibre ebook manager";
  };

  config = lib.mkIf config.utilities.calibre.enable {
    services.flatpak.packages = [
      {
        appId = "com.calibre_ebook.calibre";
        origin = "flathub";
      }
    ];
  };
}
