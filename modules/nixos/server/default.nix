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
    ./longhorn.nix
    ./metallb.nix
    ./hello-world.nix
    ./nextcloud.nix
    ./media
  ];

  options = {
    server.enable = lib.mkEnableOption "default server modules";
  };

  config = lib.mkIf config.server.enable {
    server = {
      kubernetes.enable = lib.mkDefault true;
      longhorn.enable = lib.mkDefault true;
      metallb.enable = lib.mkDefault true;
      hello-world.enable = lib.mkDefault true;
      nextcloud.enable = lib.mkDefault true;
      media.enable = lib.mkDefault true;
    };
  };
}
