{ config, lib, pkgs, inputs, ... }:

{
  options = {
    networking.enable = lib.mkEnableOption
      "enables networking using networkmanager, CUPS and SANE";
  };

  config = lib.mkIf config.networking.enable {
    networking.networkmanager.enable = lib.mkDefault true;
    services.printing.enable = lib.mkDefault true;
    hardware.sane.enable = lib.mkDefault true;

    hardware.sane.extraBackends = [ pkgs.epkowa ];
    services.udev.packages = [ pkgs.vuescan ];
    environment.systemPackages = [ pkgs.epson-v550-plugin ];
    system.activationScripts.iscanPluginLibraries = ''
      mkdir -p /usr/share/iscan
      mkdir -p /usr/lib/iscan
      ln -s ${pkgs.epson-v550-plugin}/share/iscan/* /usr/share/iscan
      ln -s ${pkgs.epson-v550-plugin}/lib/iscan/* /usr/lib/iscan
    '';
  };
}
