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

    environment.systemPackages = [
      (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background=${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images_dark/5120x2880.png
      '')
      pkgs.kdePackages.spectacle
      pkgs.kdePackages.discover
      pkgs.kdePackages.krdp
      pkgs.kdePackages.kalk
      pkgs.kdePackages.kamoso
    ];
  };
}
