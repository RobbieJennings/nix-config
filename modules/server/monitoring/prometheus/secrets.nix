{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.prometheus-secrets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config =
        lib.mkIf
          (config.monitoring.prometheus.enable && config.secrets.enable && config.secrets.prometheus.enable)
          {
            sops = {
              secrets = {
                "prometheus/aws_access_key" = { };
                "prometheus/aws_secret_key" = { };
              };
              templates = {
                prometheus-thanos-secrets = {
                  content = builtins.toJSON {
                    apiVersion = "v1";
                    kind = "Secret";
                    metadata = {
                      name = "prometheus-thanos-secrets";
                      namespace = "monitoring";
                    };
                    type = "Opaque";
                    stringData = {
                      thanos-config = ''
                        type: S3
                        config:
                          bucket: prometheus-thanos-bucket
                          endpoint: garage.garage.svc.cluster.local:3900
                          insecure: true
                          access_key: ${config.sops.placeholder."prometheus/aws_access_key"}
                          secret_key: ${config.sops.placeholder."prometheus/aws_secret_key"}
                      '';
                    };
                  };
                  path = "/var/lib/rancher/k3s/server/manifests/prometheus-thanos-secrets.json";
                };
              };
            };
          };
    };
}
