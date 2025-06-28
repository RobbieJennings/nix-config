{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./discover.nix
    ./calculator.nix
    ./camera.nix
    ./screenshot.nix
    ./vlc.nix
    ./remote-desktop.nix
    ./office.nix
    ./spotify.nix
    ./calibre.nix
  ];

  options = {
    utilities.enable = lib.mkEnableOption "all utility applications";
  };

  config = lib.mkIf config.utilities.enable {
    utilities = {
      discover.enable = lib.mkDefault true;
      screenshot.enable = lib.mkDefault true;
      vlc.enable = lib.mkDefault true;
      camera.enable = lib.mkDefault true;
      calculator.enable = lib.mkDefault true;
      remoteDesktop.enable = lib.mkDefault true;
      office.enable = lib.mkDefault true;
      spotify.enable = lib.mkDefault true;
      calibre.enable = lib.mkDefault true;
    };
  };
}
