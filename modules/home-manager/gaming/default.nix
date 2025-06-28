{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./heroic.nix
    ./lutris.nix
    ./prism.nix
  ];

  options = {
    gaming.enable = lib.mkEnableOption "all gaming clients";
  };

  config = lib.mkIf config.web.enable {
    gaming = {
      heroic.enable = lib.mkDefault true;
      lutris.enable = lib.mkDefault true;
      prism.enable = lib.mkDefault true;
    };
  };
}
