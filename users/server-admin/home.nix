{
  username,
  gitUserName,
  gitUserEmail,
  secrets,
  ...
}:

{
  lib,
  pkgs,
  homeManagerModules,
  ...
}:

{
  imports = [ homeManagerModules ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };

  programs.git = {
    enable = true;
    userEmail = gitUserEmail;
    userName = gitUserName;
  };

  inherit secrets;

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
