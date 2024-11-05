{ config, lib, pkgs, inputs, ... }:

{
  users.users.robbie = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkManager" "libvirtd" ];
    hashedPasswordFile = config.sops.secrets.password.path;
  };

  environment.persistence."/persist" = {
    users.robbie = {
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

  home-manager.users.robbie = import ./home.nix;
}
