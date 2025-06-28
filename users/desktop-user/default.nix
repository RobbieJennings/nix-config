let
  home = import ./home.nix;
  password = import ./password.nix;
  persist = import ./persist.nix;
in
{
  mkUser =
    username:
    { config, lib, ... }:
    {
      config = lib.mkMerge [
        {
          users.users.${username} = {
            isNormalUser = true;
            extraGroups = [
              "networkManager"
              "libvirtd"
            ];
            initialPassword = lib.mkDefault "password";
          };
        }

        {
          home-manager.users.${username} = home.mkHome username;
        }

        (lib.mkIf config.secrets.enable {
          sops.secrets = password.mkSecret username;
          users.users = password.mkUser config username;
        })

        (lib.mkIf config.impermanence.enable {
          environment.persistence."/persist" = persist.mkPersist username;
        })
      ];
    };
}
