{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    editing.vuescan.enable = lib.mkEnableOption "vuescan scanning app";
    secrets.vuescan.enable = lib.mkEnableOption "vuescan license secrets";
  };

  config = lib.mkMerge [
    (lib.mkIf config.editing.vuescan.enable {
      home.packages = [ pkgs.vuescan ];
    })

    (lib.mkIf (config.editing.vuescan.enable && config.secrets.enable && config.secrets.vuescan.enable)
      {
        sops = {
          secrets = {
            "vuescan/user_id" = { };
            "vuescan/email_address" = { };
            "vuescan/customer_number" = { };
            "vuescan/serial_number" = { };
          };
          templates.".vuescanrc".content = ''
            UserID=${config.sops.placeholder."vuescan/user_id"}
            SerialNumber=${config.sops.placeholder."vuescan/serial_number"}
            CustomerNumber=${config.sops.placeholder."vuescan/customer_number"}
            EmailAddress=${config.sops.placeholder."vuescan/email_address"}
          '';
        };
        home.activation."vuescanrc" = ''
          ln -sf ${config.sops.templates.".vuescanrc".path} ~/.vuescanrc
        '';
      }
    )
  ];
}
