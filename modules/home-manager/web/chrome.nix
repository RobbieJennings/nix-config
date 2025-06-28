{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    web.chrome.enable = lib.mkEnableOption "chrome web browser";
  };

  config = lib.mkIf config.web.chrome.enable {
    services.flatpak.packages = [
      {
        appId = "com.google.Chrome";
        origin = "flathub";
      }
    ];
  };
}
