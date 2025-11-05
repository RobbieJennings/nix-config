{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./kubernetes.nix
    ./metallb.nix
    ./longhorn.nix
    ./hello-world.nix
    ./jellyfin.nix
  ];

  options = {
    server.enable = lib.mkEnableOption "default server modules";
  };

  config = lib.mkIf config.server.enable {
    server = {
      kubernetes.enable = lib.mkDefault true;
      metallb.enable = lib.mkDefault true;
      longhorn.enable = lib.mkDefault true;
      hello-world.enable = lib.mkDefault true;
      jellyfin.enable = lib.mkDefault true;
    };
  };
}
