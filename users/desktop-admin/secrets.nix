{ config, lib, ... }:

{
  config = lib.mkIf config.secrets.enable {
    sops.secrets = {
      "vuescan/user_id" = { };
      "vuescan/email_address" = { };
      "vuescan/customer_number" = { };
      "vuescan/serial_number" = { };
      "restic/repository" = { };
      "restic/password" = { };
      "rclone/client_id" = { };
      "rclone/client_secret" = { };
      "rclone/access_token" = { };
    };
  };
}
