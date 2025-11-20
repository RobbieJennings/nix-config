{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./longhorn.nix
  ];

  options = {
    server.storage.enable = lib.mkEnableOption "longhorn storage on k3s";
  };

  config = lib.mkIf config.server.storage.enable {
    server.storage.longhorn.enable = lib.mkDefault true;
  };
}
