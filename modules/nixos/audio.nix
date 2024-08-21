{ config, lib, pkgs, inputs, outputs, ... }:

{
  options = {
    audio.enable = lib.mkEnableOption "enables audio using pipewire";
  };

  config = lib.mkIf config.audio.enable {
    services.pipewire = {
      enable = lib.mkDefault true;
      pulse.enable = lib.mkDefault true;
    };
  };
}
