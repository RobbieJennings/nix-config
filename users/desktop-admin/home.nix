{
  mkHome = username: enableSecrets:
    { config, lib, pkgs, inputs, homeManagerModules, ... }: {
      imports = [ homeManagerModules ./secrets.nix ];

      home.username = username;
      home.homeDirectory = "/home/${username}";

      secrets.enable = enableSecrets;
      cosmic-manager.enable = true;
      plasma-manager.enable = true;
      utilities.enable = true;
      web.enable = true;
      gaming.enable = true;
      photography.enable = true;

      programs.git = {
        enable = true;
        userEmail = "robbie.jennings97@gmail.com";
        userName = "robbiejennings";
      };

      programs.vscode = {
        enable = true;
        profiles.default.extensions = with pkgs.vscode-extensions;
          [ bbenoist.nix ];
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
    };
}
