{ inputs, ... }:

let
  overlays = import ../overlays { inherit inputs; };
  nixosModules = import ../modules/nixos;
  homeManagerModules = import ../modules/home-manager;
  defaults = [
    inputs.home-manager.nixosModules.home-manager
    {
      imports = [ nixosModules ];
      nix.settings = {
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
      nixpkgs = {
        config.allowUnfree = true;
        overlays = [
          overlays.additions
          overlays.modifications
          overlays.unstable-packages
        ];
      };
      users.mutableUsers = false;
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs homeManagerModules; };
      };
      system.stateVersion = "25.05";
    }
  ];
in
{
  mkSystem =
    {
      system,
      host,
      platform,
      hostname,
      secrets ? {
        enable = false;
      },
      impermanence ? {
        enable = false;
      },
      users,
      extra ? { },
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs nixosModules; };
      modules =
        defaults
        ++ [
          (import ../hosts/${host} { inherit inputs; })
          (import ../platforms/${platform} { inherit inputs; })
          { inherit secrets impermanence; }
          { networking.hostName = hostname; }
          extra
        ]
        ++ builtins.map ({ user, username, ... }: import ../users/${user} { inherit username; }) users
        ++ builtins.map (
          {
            username,
            gitUserName,
            gitUserEmail,
            secrets ? {
              enable = false;
            },
            ...
          }:
          { config, lib, ... }:
          {
            config = lib.mkMerge [
              {
                home-manager.users.${username} = {
                  inherit secrets;
                  imports = [ homeManagerModules ];
                  home = {
                    inherit username;
                    homeDirectory = "/home/${username}";
                    stateVersion = "25.05";
                  };
                  programs = {
                    home-manager.enable = true;
                    git = {
                      userName = gitUserName;
                      userEmail = gitUserEmail;
                    };
                  };
                };
              }
              (lib.mkIf (config.secrets.enable && config.secrets.passwords.enable) {
                sops.secrets."passwords/${username}".neededForUsers = true;
                users.users.${username} = {
                  initialPassword = null;
                  hashedPasswordFile = config.sops.secrets."passwords/${username}".path;
                };
              })
            ];
          }
        ) users;
    };
}
