{
  inputs,
  ...
}:
{
  flake.modules.nixos.tailscale-operator =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "tailscale-operator";
        repo = "https://pkgs.tailscale.com/helmcharts";
        version = "1.94.2";
        hash = "sha256-BtZ24mCT2GMHE9iR+2xuIkB+4m1r2OC3WLkY3jC3i3I=";
      };
      image = pkgs.dockerTools.pullImage {
        imageName = "tailscale/k8s-operator";
        imageDigest = "sha256:7956bd50dca9dc804b98720df94d112b54af85449ed0bf8cc7fad0346b225067";
        sha256 = "sha256-4sb4yFLR+rpquzbdT15OM1QzxRl5uksEuExnfbx1+MQ=";
        finalImageTag = "v1.94.2";
        arch = "amd64";
      };
    in
    {
      options = {
        tailscale-operator.enable = lib.mkEnableOption "Tailscale Kubernetes Operator";
        secrets.tailscale-operator.enable = lib.mkEnableOption "Enable SOPS-managed OAuth secret for Tailscale operator";
      };

      config = lib.mkMerge [
        (lib.mkIf config.tailscale-operator.enable {
          services.k3s = {
            images = [ image ];
            autoDeployCharts.tailscale-operator = chart // {
              targetNamespace = "tailscale";
              createNamespace = true;
              values = {
                operatorConfig = {
                  image = {
                    repository = image.imageName;
                    tag = image.imageTag;
                  };
                  resources = {
                    requests.cpu = "10m";
                    requests.memory = "32Mi";
                    limits.cpu = "100m";
                    limits.memory = "128Mi";
                  };
                };
              };
            };
          };
        })
        (lib.mkIf
          (
            config.tailscale-operator.enable
            && config.secrets.enable
            && config.secrets.tailscale-operator.enable
          )
          {
            sops.secrets = {
              "tailscale/client_id" = { };
              "tailscale/client_secret" = { };
              "tailscale/device_id" = { };
              "tailscale/key" = { };
            };
            sops.templates.tailscaleOperatorOAuth = {
              content = builtins.toJSON {
                apiVersion = "v1";
                kind = "Secret";
                metadata = {
                  name = "operator-oauth";
                  namespace = "tailscale";
                };
                type = "Opaque";
                immutable = true;
                stringData = {
                  client_id = config.sops.placeholder."tailscale/client_id";
                  client_secret = config.sops.placeholder."tailscale/client_secret";
                };
              };
              path = "/var/lib/rancher/k3s/server/manifests/tailscale-operator-oauth.json";
            };
          }
        )
      ];
    };
}
