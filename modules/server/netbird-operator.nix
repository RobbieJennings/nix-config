{
  inputs,
  ...
}:
{
  flake.modules.nixos.netbird-operator =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "kubernetes-operator";
        repo = "https://netbirdio.github.io/helms";
        version = "0.3.1";
        hash = "sha256-MWO1YYzbXxT+OCmjAeGchsp1bl/Dw4D0TQKXHlwIvw0=";
      };
      operatorImage = pkgs.dockerTools.pullImage {
        imageName = "netbirdio/kubernetes-operator";
        imageDigest = "sha256:57740157b4d7c0ce1356f6c1c3cc0f4c6573600eadbee642334b3070fb51899a";
        sha256 = "sha256-bnpB50R8k6POBq+IuZ9UpA0qdw6qhEmIoQXx9EzYrbY=";
        finalImageTag = "0.3.1";
        arch = "amd64";
      };
      routerImage = pkgs.dockerTools.pullImage {
        imageName = "netbirdio/netbird";
        imageDigest = "sha256:b1487a94f432aa706275ebbbbdff3605bf927b056d63855f3d43966cb68c64dc";
        sha256 = "sha256-fMR/IP3PM/fQfYkl+IeoTWkp++oFY9NGu7MP/qb29W8=";
        finalImageTag = "0.70.0-rootless";
        arch = "amd64";
      };
    in
    {
      options = {
        netbird-operator.enable = lib.mkEnableOption "Netbird Kubernetes Operator";
        secrets.netbird-operator.enable = lib.mkEnableOption "Enable SOPS-managed OAuth secret for Netbird operator";
      };

      config = lib.mkMerge [
        (lib.mkIf config.netbird-operator.enable {
          services.k3s = {
            images = [
              operatorImage
              routerImage
            ];
            autoDeployCharts = {
              netbird-operator = chart // {
                targetNamespace = "netbird";
                createNamespace = true;
                values = {
                  operator.image = {
                    repository = operatorImage.imageName;
                    tag = operatorImage.imageTag;
                  };
                  routingClientImage = "${routerImage.imageName}:${routerImage.imageTag}";
                  resources = {
                    requests.cpu = "100m";
                    requests.memory = "128Mi";
                    limits.cpu = "250m";
                    limits.memory = "256Mi";
                  };
                };
                extraDeploy = [
                  {
                    apiVersion = "netbird.io/v1alpha1";
                    kind = "NetworkRouter";
                    metadata = {
                      name = "homelab";
                      namespace = "netbird";
                    };
                    spec = {
                      dnsZoneRef.name = "homelab";
                      workloadOverride = {
                        replicas = 1;
                        podTemplate.spec = {
                          dnsConfig.options = [
                            {
                              name = "ndots";
                              value = "0";
                            }
                          ];
                          resources = {
                            requests.cpu = "100m";
                            requests.memory = "128Mi";
                            limits.cpu = "250m";
                            limits.memory = "256Mi";
                          };
                        };
                      };
                    };
                  }
                ];
              };
            };
          };
        })
        (lib.mkIf
          (config.netbird-operator.enable && config.secrets.enable && config.secrets.netbird-operator.enable)
          {
            sops.secrets = {
              "netbird/key" = { };
            };
            sops.templates.netbirdMgmtApiKey = {
              content = builtins.toJSON {
                apiVersion = "v1";
                kind = "Secret";
                metadata = {
                  name = "netbird-mgmt-api-key";
                  namespace = "netbird";
                };
                type = "Opaque";
                immutable = true;
                stringData = {
                  NB_API_KEY = config.sops.placeholder."netbird/key";
                };
              };
              path = "/var/lib/rancher/k3s/server/manifests/netbird-mgmt-api-key.json";
            };
          }
        )
      ];
    };
}
