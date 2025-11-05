{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    server.metallb.enable = lib.mkEnableOption "metalLB helm chart on k3s";
  };

  config = lib.mkIf config.server.metallb.enable {
    services.k3s = {
      extraFlags = [ "--disable=servicelb" ];
      autoDeployCharts.metallb = {
        name = "metallb";
        repo = "https://metallb.github.io/metallb";
        version = "0.15.2";
        hash = "sha256-Tw/DE82XgZoceP/wo4nf4cn5i8SQ8z9SExdHXfHXuHM=";
        targetNamespace = "metallb-system";
        createNamespace = true;
        values = {
          # TODO
        };
        extraDeploy = [
          {
            apiVersion = "metallb.io/v1beta1";
            kind = "IPAddressPool";
            metadata = {
              name = "default";
              namespace = "metallb-system";
            };
            spec = {
              addresses = [ "192.168.0.200-192.168.0.210" ];
              autoAssign = true;
            };
          }
          {
            apiVersion = "metallb.io/v1beta1";
            kind = "L2Advertisement";
            metadata = {
              name = "default";
              namespace = "metallb-system";
            };
            spec = {
              ipAddressPools = [ "default" ];
            };
          }
        ];
      };
    };
  };
}
