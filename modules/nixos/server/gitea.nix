{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  chart = {
    name = "gitea";
    repo = "https://dl.gitea.io/charts";
    version = "12.4.0";
    hash = "sha256-AAs1JMBWalE0PE4WJUHy6aNMcouETl+LV1IqW31tsn4=";
  };
  giteaImage = pkgs.dockerTools.pullImage {
    imageName = "gitea/gitea";
    imageDigest = "sha256:2edc102cbb636ae1ddac5fa0c715aa5b03079dee13ac6800b2cef6d4e912e718";
    sha256 = "sha256-ovGz6WbtnVntxRt/py4iKg4ZnCj90DK/hQwpgdk/D3I=";
    finalImageTag = "1.24.6";
    arch = "amd64";
  };
  postgresqlImage = pkgs.dockerTools.pullImage {
    imageName = "bitnamilegacy/postgresql";
    imageDigest = "sha256:926356130b77d5742d8ce605b258d35db9b62f2f8fd1601f9dbaef0c8a710a8d";
    sha256 = "sha256-cKcahA8r6524qghk9QMYUtG5oGQTKMVme29Lz9lQOGU=";
    finalImageTag = "17.6.0-debian-12-r4";
    arch = "amd64";
  };
  valkeyImage = pkgs.dockerTools.pullImage {
    imageName = "bitnamilegacy/valkey";
    imageDigest = "sha256:4f0191fba7d3ffc38362381fa0ecac3c570dac56621278bcda513b477c8308c4";
    sha256 = "sha256-8bOuxrEB2dU2Us+N5MnP9tIqLnIDOsw0UA3+wSWlz9M=";
    finalImageTag = "8.1.3-debian-12-r3";
    arch = "amd64";
  };
in
{
  options = {
    server.gitea.enable = lib.mkEnableOption "Gitea Helm chart on k3s";
  };

  config = lib.mkIf config.server.gitea.enable {
    services.k3s = {
      images = [
        giteaImage
        postgresqlImage
        valkeyImage
      ];
      autoDeployCharts.gitea = chart // {
        targetNamespace = "gitea";
        createNamespace = true;
        values = {
          image = {
            registry = "docker.io";
            repository = giteaImage.imageName;
            tag = giteaImage.imageTag;
          };
          gitea = {
            admin = {
              username = "admin";
              password = "changeme";
              email = "admin@local";
            };
            config = {
              database.DB_TYPE = "postgres";
              indexer = {
                ISSUE_INDEXER_TYPE = "bleve";
                REPO_INDEXER_ENABLED = true;
              };
              server = {
                DOMAIN = "192.168.0.204";
                ROOT_URL = "http://192.168.0.204/";
              };
            };
          };
          service = {
            http = {
              type = "LoadBalancer";
              loadBalancerIP = "192.168.0.204";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.universe.tf/allow-shared-ip" = "gitea";
              };
            };
            ssh = {
              type = "LoadBalancer";
              loadBalancerIP = "192.168.0.204";
              annotations = {
                "metallb.io/address-pool" = "default";
                "metallb.universe.tf/allow-shared-ip" = "gitea";
              };
            };
          };
          persistence = {
            enabled = true;
            size = "10Gi";
          };
          postgresql-ha.enabled = false;
          postgresql = {
            enabled = true;
            image = {
              repository = postgresqlImage.imageName;
              tag = postgresqlImage.imageTag;
            };
            primary.persistence = {
              enabled = true;
              size = "8Gi";
            };
          };
          valkey-cluster.enabled = false;
          valkey = {
            enabled = true;
            image = {
              repository = valkeyImage.imageName;
              tag = valkeyImage.imageTag;
            };
            primary.persistence = {
              enabled = true;
              size = "8Gi";
            };
            replica = {
              replicaCount = 1;
              persistence = {
                enabled = true;
                size = "8Gi";
              };
            };
          };
        };
      };
    };
  };
}
