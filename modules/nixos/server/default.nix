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
    ./hello-world.nix
    ./longhorn.nix
    ./jellyfin.nix
  ];

  options = {
    server.enable = lib.mkEnableOption "default server modules";
  };

  config = lib.mkIf config.server.enable {
    server = {
      kubernetes.enable = lib.mkDefault true;
      hello-world.enable = lib.mkDefault true;
      longhorn.enable = lib.mkDefault true;
      jellyfin.enable = lib.mkDefault true;
    };
  };
}
