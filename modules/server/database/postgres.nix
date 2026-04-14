{
  inputs,
  ...
}:
{
  flake.modules.nixos.postgres =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "cloudnative-pg";
        repo = "https://cloudnative-pg.github.io/charts";
        version = "0.28.0";
        hash = "sha256-gdN4lPNgbfm9kcVRkFP0GnnoM9KKyiUv+zkpTLnLGa4=";
      };
      image = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/cloudnative-pg/cloudnative-pg";
        imageDigest = "sha256:68074486205a33ed41928761e22ad48278c690feebe8316727a1c6b3380f9e5e";
        sha256 = "sha256-UWieKoPlh4RvK73QJcOC9+76kYzKruSsh5+uZZELVnU=";
        finalImageTag = "1.29.0";
        arch = "amd64";
      };
      postgresImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/cloudnative-pg/postgresql";
        imageDigest = "sha256:d879dfab951cb0eef9beac367f259d08ea1c04ae84699526854ff9ae478656be";
        sha256 = "sha256-ngZW2rMlOaGm/VbSR2AHGCQis88zt+S2I++Oi6hqcKE=";
        finalImageTag = "18.3-standard-trixie";
        arch = "amd64";
      };
    in
    {
      options = {
        postgres.enable = lib.mkEnableOption "Cloudnative-pg helm chart on k3s";
      };

      config = lib.mkIf config.postgres.enable {
        services.k3s = {
          images = [
            image
            postgresImage
          ];
          autoDeployCharts = {
            cloudnative-pg = chart // {
              targetNamespace = "database";
              createNamespace = true;
              values = {
                image = {
                  repository = image.imageName;
                  tag = image.imageTag;
                };
                resources = {
                  requests.cpu = "100m";
                  requests.memory = "128Mi";
                  limits.cpu = "200m";
                  limits.memory = "256Mi";
                };
              };
              extraDeploy = [
                {
                  apiVersion = "postgresql.cnpg.io/v1";
                  kind = "ClusterImageCatalog";
                  metadata = {
                    name = "postgresql-global";
                  };
                  spec = {
                    images = [
                      {
                        major = 18;
                        image = "${postgresImage.imageName}:${postgresImage.imageTag}";
                      }
                    ];
                  };
                }
              ];
            };
          };
        };
      };
    };
}
