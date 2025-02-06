{
  mkUser = username:
    {
      users.users.${username} = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkManager" "libvirtd" ];
#         hashedPasswordFile = config.sops.secrets.password.path;
        initialPassword = "password";
      };

      home-manager.users.${username} = import ./home.nix;

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
    };
}
