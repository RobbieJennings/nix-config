{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    desktop.kde-plasma.enable = lib.mkEnableOption "kde plasma desktop environment";
  };

  config = lib.mkIf config.desktop.kde-plasma.enable {
    services.desktopManager.plasma6.enable = true;

    services.displayManager = {
      sddm = {
        enable = true;
        theme = lib.mkDefault "breeze";
      };
    };

    programs.partition-manager.enable = true;
    environment.systemPackages = [
      pkgs.kdePackages.spectacle
      pkgs.kdePackages.discover
      pkgs.kdePackages.krdp
      pkgs.kdePackages.krdc
      pkgs.kdePackages.kalk
      pkgs.snapshot
      pkgs.kdePackages.skanpage
      pkgs.kdePackages.isoimagewriter
      pkgs.kdePackages.filelight
    ]
    ++ (
      if config.theme.enable then
        [
          (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
            [General]
            background=${(pkgs.fetchurl config.theme.image)}
          '')
        ]
      else
        [ ]
    );

    stylix.targets.qt.enable = lib.mkForce false;
    home-manager.sharedModules = [
      {
        stylix.targets.qt.enable = lib.mkForce false;
        plasma-manager.enable = lib.mkDefault true;
      }
    ];
  };
}
