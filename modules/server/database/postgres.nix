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
        version = "0.29.1";
        hash = "sha256-tT05kf6EvPOHZ+dwLK54ZmJlQnoSeib/8WirQgfSsd8=";
      };
      barmanPluginChart = {
        name = "plugin-barman-cloud";
        repo = "https://cloudnative-pg.github.io/charts";
        version = "0.8.1";
        hash = "sha256-mtC55W2id3oaAmn+r3IV4YKX6ci1cw4ErLJ7XUYulFY=";
      };
      operatorImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/cloudnative-pg/cloudnative-pg";
        imageDigest = "sha256:923c267ec29636db3bee20f993d0ec4973fa22998e1adad37da79e4d32b5bc07";
        hash = "sha256-RMFrp/WKFCRqya08mKu4CPTk2fPl0sgTXdSoVIr0sqA=";
        finalImageTag = "1.30.1";
        arch = "amd64";
      };
      barmanPluginImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/cloudnative-pg/plugin-barman-cloud";
        imageDigest = "sha256:c75acad19a36e8176cfe2885761ff1b836c6ef977d7257e298c99a28b5c302ef";
        hash = "sha256-yA6v6LNfu9/l6ft/tzQdKLpuO5aA8vyEqoO6JJydv28=";
        finalImageTag = "v0.15.1";
        arch = "amd64";
      };
      postgresImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/cloudnative-pg/postgresql";
        imageDigest = "sha256:c7747d8d1049fff9cf30d9cd83d14d609c957afb5ffbcd114145f393ea1850e1";
        hash = "sha256-Ggijl5weMGktrpDOFY7moKvAbvH2R7oazNygB+Z79SQ=";
        finalImageTag = "18.6-standard-trixie";
        arch = "amd64";
      };
      pgvectorImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/cloudnative-pg/pgvector";
        imageDigest = "sha256:aa637d323d4f11df5f319228836b20254d9e9285a128b51f77ab0d10682ca76f";
        hash = "sha256-GzvTR8FNaNPYObgJIvKB1cjsTAhcwDSxPNciZu6vYwE=";
        finalImageTag = "0.8.7-18-trixie";
        arch = "amd64";
      };
      vchordImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/tensorchord/vchord-scratch";
        imageDigest = "sha256:bdea43bed2a414e21bbf71767bf6f0739747ac480b267b51772dc214ac28dcb3";
        hash = "sha256-UYwrm7z7+B3eX0t0hrplSIdIjx6NXydVhpEMUIbOsks=";
        finalImageTag = "pg18-v1.1.1";
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
            pgvectorImage
            vchordImage
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
                        extensions = [
                          {
                            name = "pgvector";
                            image.reference = "${pgvectorImage.imageName}:${pgvectorImage.imageTag}";
                          }
                          {
                            name = "vchord";
                            image.reference = "${vchordImage.imageName}:${vchordImage.imageTag}";
                            dynamic_library_path = [ "/usr/lib/postgresql/18/lib/" ];
                            extension_control_path = [ "/usr/share/postgresql/18/" ];
                          }
                        ];
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
