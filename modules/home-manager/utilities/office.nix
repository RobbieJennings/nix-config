{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    utilities.office.enable = lib.mkEnableOption "enables libreoffice suite";
  };

  config = lib.mkIf config.utilities.office.enable {
    services.flatpak.packages = [
      {
        appId = "org.libreoffice.LibreOffice";
        origin = "flathub";
      }
    ];
  };
}
