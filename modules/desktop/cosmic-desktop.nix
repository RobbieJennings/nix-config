{
  inputs,
  ...
}:
{
  flake.modules.nixos.cosmic-desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        cosmic-desktop.enable = lib.mkEnableOption "cosmic desktop environment";
      };

      config = lib.mkIf config.cosmic-desktop.enable {
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
          pkgs.pavucontrol # volume control
        ];

        stylix.targets.gtk.enable = lib.mkForce false;
        home-manager.sharedModules = [
          {
            imports = [ inputs.self.modules.homeManager.cosmic-manager ];
            stylix.targets.gtk.enable = lib.mkForce false;
          }
        ];

        nixpkgs.overlays = [
          # Don't want applet in system tray
          (final: prev: {
            networkmanagerapplet = prev.networkmanagerapplet.overrideAttrs (old: {
              mesonFlags = (lib.lists.remove "-Dappindicator=yes" (old.mesonFlags or [ ])) ++ [
                "-Dappindicator=no"
              ];
            });
          })
        ];
      };
    };
}
