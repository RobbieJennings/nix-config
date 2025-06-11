{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ ./kubernetes.nix ./hello-world.nix ./longhorn.nix ./jellyfin.nix ];

  options = {
    server.enable = lib.mkEnableOption "enables default server modules";
  };

  config = lib.mkIf config.server.enable {
    server.kubernetes.enable = lib.mkDefault true;
    server.hello-world.enable = lib.mkDefault true;
    server.longhorn.enable = lib.mkDefault true;
    server.jellyfin.enable = lib.mkDefault true;
  };
}
