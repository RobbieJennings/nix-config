{ config, pkgs, pkgs-unstable, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.robbie = import ./home.nix;
}
