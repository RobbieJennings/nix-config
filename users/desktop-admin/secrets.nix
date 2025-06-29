{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.secrets.enable {
    sops = {
      defaultSopsFile = ../../secrets/${config.home.username}.yaml;
      age.sshKeyPaths = [ "/home/${config.home.username}/.ssh/id_ed25519" ];
      secrets = {
        "vuescan/user_id" = { };
        "vuescan/email_address" = { };
        "vuescan/customer_number" = { };
        "vuescan/serial_number" = { };
      };
    };
  };
}
