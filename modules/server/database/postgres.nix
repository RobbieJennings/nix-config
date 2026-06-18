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
      cnpgChart = {
        name = "cloudnative-pg";
        repo = "https://cloudnative-pg.github.io/charts";
        version = "0.28.2";
        hash = "sha256-Q8gCniyIUnz96N0Z2I/RIPZ1ZfV4iyE6N95D7pb2TmQ=";
      };
      barmanPluginChart = {
        name = "plugin-barman-cloud";
        repo = "https://cloudnative-pg.github.io/charts";
        version = "0.7.0";
        hash = "sha256-aDSUwEzJT30zxKxfPY1kwgljS0i9DoTaMdfR+tIs3Ns=";
      };
      operatorImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/cloudnative-pg/cloudnative-pg";
        imageDigest = "sha256:0dfff19ba7b52ca25851a1010028b6940fff2e233290465af1cfb08a5f3f4661";
        hash = "sha256-zt741Ql1ILjDLNQn8XzmTQmds4407P8h9xtlArL+fmA=";
        finalImageTag = "1.29.1";
        arch = "amd64";
      };
      barmanPluginImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/cloudnative-pg/plugin-barman-cloud";
        imageDigest = "sha256:71589dbac582333442812b07b31f7ea4d00324a8358aac7ca507dabf9f4b6c96";
        hash = "sha256-nyUky+FGRG2eVeDVeMputmWCpEeXs8cAB0TTFTScBUA=";
        finalImageTag = "v0.13.0";
        arch = "amd64";
      };
      postgresImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/cloudnative-pg/postgresql";
        imageDigest = "sha256:d879dfab951cb0eef9beac367f259d08ea1c04ae84699526854ff9ae478656be";
        hash = "sha256-ngZW2rMlOaGm/VbSR2AHGCQis88zt+S2I++Oi6hqcKE=";
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
            operatorImage
            postgresImage
            barmanPluginImage
          ];
          autoDeployCharts = {
            cloudnative-pg = cnpgChart // {
              targetNamespace = "cnpg-system";
              createNamespace = true;
              values = {
                image = {
                  repository = operatorImage.imageName;
                  tag = operatorImage.imageTag;
                };
                resources = config.server.resources.profiles.infraLarge;
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
            barman-plugin = barmanPluginChart // {
              targetNamespace = "cnpg-system";
              createNamespace = true;
              values = {
                image = {
                  repository = barmanPluginImage.imageName;
                  tag = barmanPluginImage.imageTag;
                };
                resources = config.server.resources.profiles.infraLarge;
              };
            };
          };
        };
      };
    };
}
