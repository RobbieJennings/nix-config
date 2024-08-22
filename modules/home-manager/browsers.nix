{ config, lib, pkgs, inputs, ... }:

{
  options = {
    firefox.enable = lib.mkEnableOption "enables firefox browser";
    chrome.enable = lib.mkEnableOption "enables chrome browser";
    brave.enable = lib.mkEnableOption "enables brave web browser";
  };

  config = lib.mkMerge [
    (
      lib.mkIf config.firefox.enable {
        services.flatpak.packages = [ { appId = "org.mozilla.firefox"; origin = "flathub"; } ];
      }
    )
    (
      lib.mkIf config.chrome.enable {
        services.flatpak.packages = [ { appId = "com.google.Chrome"; origin = "flathub"; } ];
      }
    )
    (
      lib.mkIf config.brave.enable {
        services.flatpak.packages = [ { appId = "com.brave.Browser"; origin = "flathub"; } ];
      }
    )
  ];
}

