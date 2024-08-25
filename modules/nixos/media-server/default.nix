{ config, lib, pkgs, inputs, ... }:

{
  options = {
    mediaServer.enable = lib.mkEnableOption "enables jellyfin media server";
  };

  config = lib.mkIf config.mediaServer.enable {
    services.jellyfin.enable = true;
  };
}
