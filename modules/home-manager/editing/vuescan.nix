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
  };

  config = lib.mkMerge [
    (lib.mkIf config.editing.vuescan.enable {
      home.packages = [ pkgs.vuescan ];
    })
    (lib.mkIf (config.editing.vuescan.enable && config.secrets.enable) {
      sops.templates.".vuescanrc".content = ''
        UserID=${config.sops.placeholder."vuescan/user_id"}
        SerialNumber=${config.sops.placeholder."vuescan/serial_number"}
        CustomerNumber=${config.sops.placeholder."vuescan/customer_number"}
        EmailAddress=${config.sops.placeholder."vuescan/email_address"}
      '';
      home.activation."vuescanrc" = ''
        ln -sf ${config.sops.templates.".vuescanrc".path} ~/.vuescanrc
      '';
    })
  ];
}
