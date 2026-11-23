{
  inputs,
  ...
}:
{
  flake.modules.nixos.secrets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      options = {
        secrets = {
          enable = lib.mkEnableOption "importing secrets using sops-nix";
          passwords.enable = lib.mkEnableOption "user password secrets";
          authorizedKeys.enable = lib.mkEnableOption "user authorized ssh keys";
        };
      };

      config = lib.mkIf config.secrets.enable {
        environment.systemPackages = [
          pkgs.sops
          pkgs.ssh-to-age
        ];

        sops = {
          defaultSopsFile = lib.mkDefault ../../secrets/${config.networking.hostName}.yaml;
          age.sshKeyPaths =
            if config.impermanence.enable then
              lib.mkDefault [ "/persist/root/.ssh/id_ed25519" ]
            else
              lib.mkDefault [ "/root/.ssh/id_ed25519" ];
        };
      };
    };

  flake.modules.homeManager.secrets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      options = {
        secrets.enable = lib.mkEnableOption "importing secrets using sops-nix";
      };

      config = lib.mkIf config.secrets.enable {
        sops = {
          defaultSopsFile = ../../secrets/${config.home.username}.yaml;
          age.sshKeyPaths = [ "/home/${config.home.username}/.ssh/id_ed25519" ];
        };
      };
    };
}
