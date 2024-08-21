{ config, lib, pkgs, inputs, outputs, ... }:

{
  users.users.robbie = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkManager" ];
    initialPassword = "password";
  };

  home-manager.users.robbie = import ./home.nix;
}
