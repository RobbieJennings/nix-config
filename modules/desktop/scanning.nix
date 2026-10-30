{
  inputs,
  ...
}:
{
  flake.modules.nixos.scanning =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        scanning.enable = lib.mkEnableOption "scanning using SANE and installs necessary drivers for Epson Perfection V550 Scanner";
      };

      config = lib.mkIf config.scanning.enable {
        hardware.sane.enable = true;
        hardware.sane.extraBackends = [ pkgs.epkowa ];
        system.activationScripts.iscanPluginLibraries = ''
          mkdir -p /usr/share/iscan /usr/lib/iscan
          ln -sf ${pkgs.epkowa.plugins.v550}/lib/esci/* /usr/lib/iscan
          ln -sf ${pkgs.epkowa.plugins.v550}/share/esci/* /usr/share/iscan
        '';
      };
    };
}
