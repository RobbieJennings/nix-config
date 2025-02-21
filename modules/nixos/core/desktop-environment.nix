{ config, lib, pkgs, inputs, ... }:

{
  options = {
    desktop-environment.enable =
      lib.mkEnableOption "enables plasma desktop environment";
  };

  config = lib.mkIf config.desktop-environment.enable {
    # Enable SDDM lgoin manager
    services.displayManager = {
      sddm = {
        enable = true;
        theme = lib.mkDefault "breeze";
      };
    };

    # Add wallpaper to SDDM theme
    environment.systemPackages = [
      (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background=${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images_dark/5120x2880.png
      '')
    ];

    # Enable KDE Plasma desktop environment
    services.desktopManager.plasma6.enable = true;
  };
}
