{ config, lib, pkgs, inputs, ... }:

{
  options = {
    photography.darktable.enable =
      lib.mkEnableOption "enables darktable editing app";
  };

  config = lib.mkIf config.photography.darktable.enable {
    services.flatpak.packages = [{
      appId = "org.darktable.Darktable";
      origin = "flathub";
    }];
  };
}
