{ username, ... }:

{ config, lib, ... }:

{
  config = {
    users.users.${username} = {
      initialPassword = lib.mkDefault "password";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkManager"
        "docker"
      ];
    };
    home-manager.users.${username} = import ./home.nix;
    environment =
      if config.impermanence.enable then import ./persist.nix { inherit username; } else { };
  };
}
