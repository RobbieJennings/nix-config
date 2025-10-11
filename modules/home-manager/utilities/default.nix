{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./vlc.nix
    ./office.nix
    ./spotify.nix
    ./calibre.nix
    ./obsidian.nix
    ./obs.nix
    ./kolourpaint.nix
  ];

  options = {
    utilities.enable = lib.mkEnableOption "all utility applications";
  };

  config = lib.mkIf config.utilities.enable {
    utilities = {
      vlc.enable = lib.mkDefault true;
      office.enable = lib.mkDefault true;
      spotify.enable = lib.mkDefault true;
      calibre.enable = lib.mkDefault true;
      obsidian.enable = lib.mkDefault true;
      obs.enable = lib.mkDefault true;
      kolourpaint.enable = lib.mkDefault true;
    };
  };
}
