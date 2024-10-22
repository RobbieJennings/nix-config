{ config, lib, pkgs, inputs, ... }:

{
  users.users.robbie = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkManager" "libvirtd" ];
    initialPassword = "password";
  };

  environment.persistence."/persist" = {
    users.robbie = {
      directories = [
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        "nix-config"
        { directory = ".gnupg"; mode = "0700"; }
        { directory = ".ssh"; mode = "0700"; }
        { directory = ".nixops"; mode = "0700"; }
        { directory = ".local/share/keyrings"; mode = "0700"; }
        ".local/share/direnv"
        ".local/share/flatpak"
        ".config"
        ".var/app/com.brave.Browser"
        ".local/share/kate"
      ];
    };
  };

  home-manager.users.robbie = import ./home.nix;
}
