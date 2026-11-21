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
          pkgs.seahorse # key management
          pkgs.file-roller # archive management
          pkgs.loupe # image viewer
          pkgs.simple-scan # document scanner
          pkgs.system-config-printer # printer setup
          pkgs.gnome-characters # emojis
          pkgs.baobab # disk analysis
          pkgs.gnome-disk-utility # disk formatting
          pkgs.popsicle # iso flashing
          pkgs.gnome-system-monitor # system monitor
          pkgs.networkmanagerapplet # advanced network configuration
          pkgs.gnome-connections # remote desktop client
          pkgs.pavucontrol # volume control
        ];

        home-manager.sharedModules = [
          {
            imports = [ inputs.self.modules.homeManager.cosmic-manager ];

            services.flatpak = {
              remotes = lib.mkOptionDefault [
                {
                  name = "cosmic";
                  location = "https://apt.pop-os.org/cosmic/cosmic.flatpakrepo";
                }
              ];
              packages = [
                {
                  appId = "dev.edfloreshz.Calculator";
                  origin = "flathub";
                }
                {
                  appId = "io.github.cosmic_utils.camera";
                  origin = "flathub";
                }
              ];
            };
          }
        ];

        nixpkgs.overlays = [
          # Override all cosmic packages with unstable versions
          (
            final: prev:
            lib.mapAttrs (name: _: prev.pkgs.unstable.${name}) (
              lib.filterAttrs (name: _: lib.hasPrefix "cosmic-" name) prev
            )
            // {
              pop-launcher = prev.pkgs.unstable.pop-launcher;
              xdg-desktop-portal-cosmic = prev.pkgs.unstable.xdg-desktop-portal-cosmic;
            }
          )

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
