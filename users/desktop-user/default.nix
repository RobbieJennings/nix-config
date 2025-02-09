let
  home = import ./home.nix;
in with home;
{
  mkUser = username: { config, lib, ... }: {
    config = (lib.mkMerge [
      ({
        home-manager.users.${username} = mkHome username;
        users.users.${username} = {
          isNormalUser = true;
          extraGroups = [ "networkManager" "libvirtd" ];
          initialPassword = lib.mkDefault "password";
        };
      })

      (lib.mkIf config.impermanence.enable {
        environment.persistence."/persist" = {
          users.${username} = {
            directories = [
              "Desktop"
              "Documents"
              "Downloads"
              "Music"
              "Pictures"
              "Videos"
              { directory = ".gnupg"; mode = "0700"; }
              { directory = ".ssh"; mode = "0700"; }
              { directory = ".nixops"; mode = "0700"; }
              { directory = ".local/share/keyrings"; mode = "0700"; }
              ".local/share/direnv"
              ".local/share/flatpak"
              ".local/share/kate"
              ".config"
              ".var"
            ];
          };
        };
      })

      (lib.mkIf config.secrets.enable {
        sops.secrets."users/${username}/password".neededForUsers = true;
        users.users.${username} = {
          initialPassword = null;
          hashedPasswordFile = config.sops.secrets."users/${username}/password".path;
        };
      })
    ]);
  };
}
