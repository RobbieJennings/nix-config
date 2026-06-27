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
        version = "0.28.3";
        hash = "sha256-oiDxdLcmN/UFVTucD92wuf7QM4DVi+Fxk1zZnYgId9Y=";
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
        imageDigest = "sha256:9dd9fda84a67a3f351885885fec02ec6346fd941965d8fd94226531fb329624a";
        hash = "sha256-nKDBrn5eq0pxsqbQOO3pBcP1lseDmayt3WN/0fF5k0s=";
        finalImageTag = "18.4-standard-trixie";
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
