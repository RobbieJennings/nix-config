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
    ./load-balancing
    ./storage
    ./media
  ];

  options = {
    server.enable = lib.mkEnableOption "default server modules";
  };

  config = lib.mkIf config.server.enable {
    server = {
      kubernetes.enable = lib.mkDefault true;
      hello-world.enable = lib.mkDefault true;
      load-balancing.enable = lib.mkDefault true;
      storage.enable = lib.mkDefault true;
      media.enable = lib.mkDefault true;
    };
  };
}
