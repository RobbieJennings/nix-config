{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    desktop.audio.enable = lib.mkEnableOption "audio using pipewire";
  };

  config = lib.mkIf config.desktop.audio.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = lib.mkDefault true;
    };
  };
}
