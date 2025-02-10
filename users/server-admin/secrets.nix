{ config, lib, ... }:

{
  config = lib.mkIf config.secrets.enable {
    sops.defaultSopsFile = ../../secrets.yaml;
    sops.age.sshKeyPaths = [ "/home/${config.home.username}/.ssh/id_ed25519" ];
  };
}
