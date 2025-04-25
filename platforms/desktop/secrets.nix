{ config, lib, pkgs, inputs, nixosModules, ... }:

{
  config = lib.mkIf config.secrets.enable {
    sops = {
      defaultSopsFile =
        lib.mkDefault ../../secrets/${config.networking.hostName}.yaml;
      age.sshKeyPaths = lib.mkDefault [ "/persist/root/.ssh/id_ed25519" ];
      secrets = { k3s-token = { }; };
    };
  };
}
