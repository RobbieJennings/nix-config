{ config, lib, pkgs, inputs, ... }:

{
  options = {
    audio.enable = lib.mkEnableOption "enables audio using pipewire";
  };

  config = lib.mkIf config.audio.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = lib.mkDefault true;
    };
  };
}
