{ config, lib, pkgs, inputs, ... }:

{
  users.users.robbie = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkManager" "libvirtd" ];
    initialPassword = "password";
  };

  home-manager.users.robbie = import ./home.nix;
}
