{ config, lib, pkgs, inputs, ... }:

{
  options = {
    media-server.enable = lib.mkEnableOption "enables nixarr media server";
  };

  config = lib.mkIf config.media-server.enable {
    nixarr = {
      enable = lib.mkDefault true;
      mediaDir = lib.mkDefault "/media";
      stateDir = lib.mkDefault "/media/.state/nixarr";

      transmission.enable = lib.mkDefault true;
      transmission.openFirewall = lib.mkDefault true;

      jellyfin.enable = lib.mkDefault true;
      jellyfin.openFirewall = lib.mkDefault true;

      bazarr.enable = lib.mkDefault true;
      bazarr.openFirewall = lib.mkDefault true;

      lidarr.enable = lib.mkDefault true;
      lidarr.openFirewall = lib.mkDefault true;

      prowlarr.enable = lib.mkDefault true;
      prowlarr.openFirewall = lib.mkDefault true;

      radarr.enable = lib.mkDefault true;
      radarr.openFirewall = lib.mkDefault true;

      readarr.enable = lib.mkDefault true;
      readarr.openFirewall = lib.mkDefault true;

      sonarr.enable = lib.mkDefault true;
      sonarr.openFirewall = lib.mkDefault true;
    };
  };
}
