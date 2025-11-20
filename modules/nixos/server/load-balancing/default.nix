{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./metallb.nix
  ];

  options = {
    server.load-balancing.enable = lib.mkEnableOption "metallb load balancing on k3s";
  };

  config = lib.mkIf config.server.load-balancing.enable {
    server.load-balancing.metallb.enable = lib.mkDefault true;
  };
}
