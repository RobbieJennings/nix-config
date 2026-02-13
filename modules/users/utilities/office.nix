{
  inputs,
  ...
}:
{
  flake.modules.homeManager.office =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        office.enable = lib.mkEnableOption "libreoffice suite";
      };

      config = lib.mkIf config.office.enable {
        services.flatpak.packages = [
          {
            appId = "org.libreoffice.LibreOffice";
            origin = "flathub";
          }
        ];
      };
    };
}
