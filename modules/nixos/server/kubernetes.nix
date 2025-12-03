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
    secrets.kubernetes.enable = lib.mkEnableOption "k3s token secret";
  };

  config = lib.mkMerge [
    (lib.mkIf config.server.kubernetes.enable {
      services.k3s = {
        enable = true;
        images = [ config.services.k3s.package.airgap-images ];
        extraFlags = [
          "--embedded-registry"
          "--disable servicelb"
          "--disable traefik"
          "--disable local-storage"
          "--disable metrics-server"
        ];
      };
    })
    (lib.mkIf
      (config.server.kubernetes.enable && config.secrets.enable && config.secrets.kubernetes.enable)
      {
        sops.secrets.k3s-token = { };
        services.k3s.tokenFile = config.sops.secrets.k3s-token.path;
      }
    )
  ];
}
