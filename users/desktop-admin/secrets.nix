{ config, lib, ... }:

{
  config = lib.mkIf config.secrets.enable {
    sops = {
      defaultSopsFile = ../../secrets/${config.home.username}.yaml;
      age.sshKeyPaths = [ "/home/${config.home.username}/.ssh/id_ed25519" ];
      secrets = { test_secret = { }; };
    };
  };
}
