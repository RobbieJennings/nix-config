{
  mkHome =
    username:
    {
      config,
      lib,
      pkgs,
      inputs,
      homeManagerModules,
      ...
    }:
    {
      imports = [ homeManagerModules ];

      home = {
        inherit username;
        homeDirectory = "/home/${username}";
      };

      programs = {
        git.enable = lib.mkDefault true;
      };

      plasma-manager.enable = lib.mkDefault true;
      utilities.enable = lib.mkDefault true;
      web.enable = lib.mkDefault true;
      gaming.enable = lib.mkDefault true;
      photography.enable = lib.mkDefault true;

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
    };
}
