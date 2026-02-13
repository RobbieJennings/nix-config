{
  inputs,
  ...
}:
{
  flake.modules.nixos.steam =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        steam.enable = lib.mkEnableOption "steam gaming client";
      };

      config = lib.mkIf config.steam.enable {
        programs.steam = {
          enable = true;
          remotePlay.openFirewall = lib.mkDefault true;
          dedicatedServer.openFirewall = lib.mkDefault true;
          localNetworkGameTransfers.openFirewall = lib.mkDefault true;
          gamescopeSession.enable = lib.mkDefault true;
        };
      };
    };
}
