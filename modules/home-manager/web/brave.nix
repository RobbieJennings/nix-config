{ config, lib, pkgs, inputs, ... }:

{
  options = {
    web.brave.enable = lib.mkEnableOption "enables brave web browser";
  };

  config = lib.mkIf config.web.brave.enable {
    services.flatpak.packages = [ { appId = "com.brave.Browser"; origin = "flathub"; } ];
  };
}
