{ config, lib, pkgs, homeManagerModules, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "robbie";
  home.homeDirectory = "/home/robbie";

  programs.git = {
    enable = true;
    userName = "RobbieJennings";
    userEmail = "robbie.jennings97@gmail.com";
  };

  home.packages = [
    pkgs.neofetch
    pkgs.unstable.neovim
  ];

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
