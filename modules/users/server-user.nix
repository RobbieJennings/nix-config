{
  self,
  inputs,
  ...
}:
{
  config.flake.factory.server-user =
    {
      moduleName,
      username,
      isAdmin,
    }:
    {
      nixos."${moduleName}" =
        {
          lib,
          pkgs,
          config,
          ...
        }:
        {
          config = lib.mkMerge [
            {
              users.users."${username}" = {
                initialPassword = lib.mkDefault "password";
                isNormalUser = true;
                home = "/home/${username}";
                extraGroups = [
                  "networkmanager"
                  "docker"
                  "libvirtd"
                ]
                ++ lib.optionals isAdmin [
                  "wheel"
                ];
              };
            }

            (lib.mkIf (config.secrets.enable && config.secrets.passwords.enable) {
              sops.secrets."passwords/${username}".neededForUsers = true;
              users.users.${username} = {
                initialPassword = null;
                hashedPasswordFile = config.sops.secrets."passwords/${username}".path;
              };
            })

            (lib.mkIf config.impermanence.enable {
              environment.persistence."/persist".users.${username} = {
                directories = [
                  "Desktop"
                  "Documents"
                  "Downloads"
                  "nix-config"
                  {
                    directory = ".ssh";
                    mode = "0700";
                  }
                  ".config"
                  ".var"
                ];
                files = [
                  ".bash_history"
                  ".zsh_history"
                ];
              };
            })
          ];
        };
    };
}
