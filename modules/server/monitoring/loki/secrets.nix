{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.loki-secrets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config =
        lib.mkIf (config.monitoring.loki.enable && config.secrets.enable && config.secrets.loki.enable)
          {
            sops = {
              secrets = {
                "loki/aws_access_key" = { };
                "loki/aws_secret_key" = { };
              };
              templates = {
                loki-secrets = {
                  content = builtins.toJSON {
                    apiVersion = "v1";
                    kind = "Secret";
                    metadata = {
                      name = "loki-secrets";
                      namespace = "monitoring";
                    };
                    type = "Opaque";
                    stringData = {
                      AWS_ACCESS_KEY_ID = config.sops.placeholder."loki/aws_access_key";
                      AWS_SECRET_ACCESS_KEY = config.sops.placeholder."loki/aws_secret_key";
                    };
                  };
                  path = "/var/lib/rancher/k3s/server/manifests/loki-secrets.json";
                };
              };
            };
          };
    };
}
