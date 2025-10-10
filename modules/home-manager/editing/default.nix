{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./vuescan.nix
    ./darktable.nix
    ./krita.nix
    ./gimp.nix
    ./kdenlive.nix
    ./audacity.nix
  ];

  options = {
    editing.enable = lib.mkEnableOption "all editing applications";
  };

  config = lib.mkIf config.editing.enable {
    editing = {
      vuescan.enable = lib.mkDefault true;
      darktable.enable = lib.mkDefault true;
      krita.enable = lib.mkDefault true;
      gimp.enable = lib.mkDefault true;
      kdenlive.enable = lib.mkDefault true;
      audacity.enable = lib.mkDefault true;
    };
  };
}
