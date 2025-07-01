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
    };
  };
}
