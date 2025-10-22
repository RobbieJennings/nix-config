{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    desktop.cosmic-desktop.enable = lib.mkEnableOption "cosmic desktop environment";
  };

  config = lib.mkIf config.desktop.cosmic-desktop.enable {
    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;
    environment.systemPackages = [
      pkgs.cosmic-ext-calculator # calculator
      pkgs.seahorse # key management
      pkgs.file-roller # archive management
      pkgs.loupe # image viewer
      pkgs.papers # document viewer
      pkgs.simple-scan # document scanner
      pkgs.system-config-printer # printer setup
      pkgs.snapshot # camera
      pkgs.gnome-characters # emojis
      pkgs.baobab # disk analysis
      pkgs.gnome-disk-utility # disk formatting
      pkgs.popsicle # iso flashing
      pkgs.gnome-system-monitor # system monitor
      pkgs.networkmanagerapplet # advanced network configuration
      pkgs.gnome-connections # remote desktop client
    ];

    stylix.targets.gtk.enable = lib.mkForce false;
    home-manager.sharedModules = [
      {
        stylix.targets.gtk.enable = lib.mkForce false;
        cosmic-manager.enable = lib.mkDefault true;
      }
    ];
  };
}
