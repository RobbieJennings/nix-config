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
                "prometheus/thanos_bucket_name" = { };
                "prometheus/thanos_aws_endpoint" = { };
                "prometheus/thanos_aws_access_key" = { };
                "prometheus/thanos_aws_secret_key" = { };
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
                          bucket: ${config.sops.placeholder."prometheus/thanos_bucket_name"}
                          endpoint: ${config.sops.placeholder."prometheus/thanos_aws_endpoint"}
                          access_key: ${config.sops.placeholder."prometheus/thanos_aws_access_key"}
                          secret_key: ${config.sops.placeholder."prometheus/thanos_aws_secret_key"}
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
