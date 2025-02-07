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

      (lib.mkIf config.secrets.enable {
        sops.secrets."password_${username}".neededForUsers = true;
        users.users.${username} = {
          initialPassword = null;
          hashedPasswordFile = config.sops.secrets."password_${username}".path;
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
              "nix-config"
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
    ]);
  };
}
