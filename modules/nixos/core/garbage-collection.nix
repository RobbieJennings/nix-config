{ config, lib, pkgs, inputs, ... }:

{
  options = {
    garbage-collection.enable = lib.mkEnableOption "enables automatic garbage collection of nix store";
  };

  config = lib.mkIf config.garbage-collection.enable {
    nix.gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 30d";
    };
  };
}
