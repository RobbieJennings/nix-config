{
  self,
  inputs,
  ...
}:
{
  config.flake.factory.desktop-user =
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

              home-manager.users."${username}" = {
                imports = [
                  inputs.self.modules.homeManager.development
                  inputs.self.modules.homeManager.utilities
                  inputs.self.modules.homeManager.web
                  inputs.self.modules.homeManager.gaming
                  inputs.self.modules.homeManager.editing
                  inputs.self.modules.homeManager.backup
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
                  "Music"
                  "Pictures"
                  "Videos"
                  "Games"
                  "Books"
                  "nix-config"
                  {
                    directory = ".ssh";
                    mode = "0700";
                  }
                  {
                    directory = ".local/share/keyrings";
                    mode = "0700";
                  }
                  {
                    directory = ".local/share/kwalletd";
                    mode = "0700";
                  }
                  ".local/share/flatpak"
                  ".local/share/Steam"
                  ".local/share/PrismLauncher"
                  ".local/state/cosmic"
                  ".local/state/cosmic-comp"
                  ".config"
                  ".var"
                  ".vscode-oss/extensions"
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
