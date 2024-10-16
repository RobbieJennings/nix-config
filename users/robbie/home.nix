{ config, lib, pkgs, inputs, homeManagerModules, ... }:

{
  imports = [
    homeManagerModules
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.username = "robbie";
  home.homeDirectory = "/home/robbie";

  utilities.enable = true;
  web.enable = true;
  gaming.enable = true;
  desktop-customisations.enable = true;

  programs.git = {
    enable = true;
    userName = "RobbieJennings";
    userEmail = "robbie.jennings97@gmail.com";
  };

  home.persistence."/persist/home/robbie" = {
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      "nix-config"
      ".gnupg"
      ".ssh"
      ".nixops"
      ".local/share/keyrings"
      ".local/share/direnv"
      ".local/share/flatpak"
      ".config"
    ];
    allowOther = false;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
