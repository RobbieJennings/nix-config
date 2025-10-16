{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    secrets.enable = lib.mkEnableOption "importing secrets using sops-nix";
    secrets.passwords.enable = lib.mkEnableOption "user password secrets";
  };

  config = lib.mkIf config.secrets.enable {
    environment.systemPackages = [
      pkgs.sops
      pkgs.ssh-to-age
    ];

    sops = {
      defaultSopsFile = lib.mkDefault ../../../secrets/${config.networking.hostName}.yaml;
      age.sshKeyPaths =
        if config.impermanence.enable then
          lib.mkDefault [ "/persist/root/.ssh/id_ed25519" ]
        else
          lib.mkDefault [ "/.ssh/id_ed25510" ];
    };
  };
}
