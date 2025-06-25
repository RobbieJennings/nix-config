{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    web.firefox.enable = lib.mkEnableOption "enables firefox web browser";
  };

  config = lib.mkIf config.web.firefox.enable {
    services.flatpak.packages = [
      {
        appId = "org.mozilla.firefox";
        origin = "flathub";
      }
    ];
  };
}
