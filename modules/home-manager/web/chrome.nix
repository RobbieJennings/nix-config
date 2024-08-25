{ config, lib, pkgs, inputs, ... }:

{
  options = {
    web.chrome.enable = lib.mkEnableOption "enables chrome web browser";
  };

  config = lib.mkIf config.web.chrome.enable {
    services.flatpak.packages = [ { appId = "com.google.Chrome"; origin = "flathub"; } ];
  };
}
