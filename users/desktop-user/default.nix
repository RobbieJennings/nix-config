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
      config = (
        lib.mkMerge [
          # Create User
          ({
            users.users.${username} = {
              isNormalUser = true;
              extraGroups = [
                "networkManager"
                "libvirtd"
              ];
              initialPassword = lib.mkDefault "password";
            };
          })

          # Add home-manager configuration
          ({ home-manager.users.${username} = home.mkHome username; })

          # Add password from secrets
          (lib.mkIf config.secrets.enable {
            sops.secrets = password.mkSecret username;
            users.users = password.mkUser config username;
          })

          # Add persistent files
          (lib.mkIf config.impermanence.enable {
            environment.persistence."/persist" = persist.mkPersist username;
          })
        ]
      );
    };
}
