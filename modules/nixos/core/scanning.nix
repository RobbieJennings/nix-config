{ config, lib, pkgs, inputs, ... }:

{
  options = {
    scanning.enable = lib.mkEnableOption
      "enables scanning using SANE and installs necessary drivers for Epson Perfection V550 Scanner";
  };

  config = lib.mkIf config.scanning.enable {
    hardware.sane.enable = lib.mkDefault true;
    hardware.sane.extraBackends = [ pkgs.epkowa ];
    services.udev.packages = [ pkgs.vuescan ];
    environment.systemPackages = [ pkgs.epson-v550-plugin ];
    system.activationScripts.iscanPluginLibraries = ''
      mkdir -p /usr/share/iscan
      mkdir -p /usr/lib/iscan
      ln -sf ${pkgs.epson-v550-plugin}/share/iscan/* /usr/share/iscan
      ln -sf ${pkgs.epson-v550-plugin}/lib/iscan/* /usr/lib/iscan
    '';
  };
}
