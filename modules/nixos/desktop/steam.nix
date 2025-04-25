{ config, lib, pkgs, inputs, ... }:

{
  options = {
    desktop.steam.enable = lib.mkEnableOption "enables steam gaming client";
  };

  config = lib.mkIf config.desktop.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = lib.mkDefault true;
      dedicatedServer.openFirewall = lib.mkDefault true;
      localNetworkGameTransfers.openFirewall = lib.mkDefault true;
      gamescopeSession.enable = lib.mkDefault true;
    };
  };
}
