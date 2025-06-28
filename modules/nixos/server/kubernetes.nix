{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    server.kubernetes.enable = lib.mkEnableOption "k3s";
  };

  config = lib.mkMerge [
    (lib.mkIf config.server.kubernetes.enable {
      services.k3s = {
        enable = true;
        images = [ config.services.k3s.package.airgapImages ];
        extraFlags = [
          "--embedded-registry"
          "--disable metrics-server"
        ];
      };
    })
    (lib.mkIf (config.server.kubernetes.enable && config.secrets.enable) {
      services.k3s.tokenFile = config.sops.secrets.k3s-token.path;
    })
  ];
}
