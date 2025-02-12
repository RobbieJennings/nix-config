{ config, lib, pkgs, inputs, ... }:

{
  options = {
    photography.vuescan.enable = lib.mkEnableOption "enables vuescan scanning app";
  };

  config = lib.mkIf config.photography.vuescan.enable {
    # TODO
  };
}
