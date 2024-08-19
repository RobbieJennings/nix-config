{ config, lib, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.robbie = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkManager" ];
    initialPassword = "password";
  };

  # Add users home configuration to home manager
  home-manager.users.robbie = import ./home.nix;
}
