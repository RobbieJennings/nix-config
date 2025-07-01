{
  username,
  gitUserName,
  gitUserEmail,
  ...
}:

{
  config,
  lib,
  ...
}:

{
  config = lib.mkMerge [
    {
      users.users.${username} = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkManager"
        ];
        initialPassword = lib.mkDefault "password";
      };

      home-manager.users.${username} = import ./home.nix {
        inherit username gitUserName gitUserEmail;
        secrets.enable = config.secrets.enable;
      };
    }

    (lib.mkIf config.impermanence.enable {
      environment.persistence."/persist" = import ./persist.nix {
        inherit username;
      };
    })

    (lib.mkIf config.secrets.enable {
      sops.secrets = {
        "passwords/${username}".neededForUsers = true;
      };
      users.users.${username} = {
        initialPassword = null;
        hashedPasswordFile = config.sops.secrets."passwords/${username}".path;
      };
    })
  ];
}
