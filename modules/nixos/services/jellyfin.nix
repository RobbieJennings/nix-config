{ config, lib, pkgs, inputs, ... }:

{
  options = {
    jellyfin.enable = lib.mkEnableOption "enables jellyfin media server";
  };

  config = lib.mkIf config.jellyfin.enable {
    services.jellyfin.enable = true;
  };
}
