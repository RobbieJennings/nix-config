{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.forgejo-valkey = self.factory.valkey {
    namespace = "forgejo";
    values = {
      resources = {
        requests.cpu = "20m";
        requests.memory = "64Mi";
        limits.cpu = "100m";
        limits.memory = "128Mi";
      };
      auth = {
        enabled = true;
        usersExistingSecret = "forgejo-secrets";
        aclUsers.default = {
          permissions = "~* &* +@all";
          passwordKey = "valkey-password";
        };
      };
    };
  };

  flake.modules.nixos.forgejo =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "forgejo";
        repo = "oci://code.forgejo.org/forgejo-helm/forgejo";
        version = "16.2.2";
        hash = "sha256-l8sEgEmCItMQO1be7wzTcQ/rsIIJK4tG7+jxItrAgo8=";
      };
      image = pkgs.dockerTools.pullImage {
        imageName = "code.forgejo.org/forgejo/forgejo";
        imageDigest = "sha256:bca6943cdd8a50f5befaf1d654bec32c9a3b6da400d23a77a829bd41f88a7263";
        sha256 = "sha256-LGR+YFcOnsL0Bt6O/ABxULKTKbNjOoHEUdAJxN49IqI=";
        finalImageTag = "14.0.4-rootless";
        arch = "amd64";
      };
    in
    {
      imports = [ inputs.self.modules.nixos.forgejo-valkey ];

      options = {
        forgejo.enable = lib.mkEnableOption "Forgejo Helm chart on k3s";
        secrets.forgejo.enable = lib.mkEnableOption "Forgejo secrets";
      };

      config = lib.mkMerge [
        (lib.mkIf config.forgejo.enable {
          forgejo-valkey.enable = true;
          services.k3s = {
            images = [ image ];
            autoDeployCharts.forgejo = chart // {
              targetNamespace = "forgejo";
              createNamespace = true;
              values = {
                image = {
                  registry = "code.forgejo.org";
                  repository = "forgejo/forgejo";
                  tag = image.imageTag;
                };
                gitea = {
                  admin.existingSecret = "forgejo-admin-secrets";
                  config = {
                    server = {
                      DOMAIN = "192.168.1.204";
                      ROOT_URL = "http://192.168.1.204:3000";
                    };
                    database = {
                      DB_TYPE = "postgres";
                      HOST = "forgejo-postgres-rw:5432";
                      NAME = "forgejo";
                      USER = "forgejo";
                    };
                    cache.ADAPTER = "redis";
                    session.PROVIDER = "redis";
                    queue.TYPE = "redis";
                    indexer = {
                      ISSUE_INDEXER_TYPE = "bleve";
                      REPO_INDEXER_ENABLED = true;
                    };
                  };
                  additionalConfigFromEnvs = [
                    {
                      name = "FORGEJO__DATABASE__PASSWD";
                      valueFrom.secretKeyRef = {
                        name = "forgejo-secrets";
                        key = "password";
                      };
                    }
                    {
                      name = "FORGEJO__CACHE__HOST";
                      valueFrom.secretKeyRef = {
                        name = "forgejo-secrets";
                        key = "valkey-url";
                      };
                    }
                    {
                      name = "FORGEJO__SESSION__PROVIDER_CONFIG";
                      valueFrom.secretKeyRef = {
                        name = "forgejo-secrets";
                        key = "valkey-url";
                      };
                    }
                    {
                      name = "FORGEJO__QUEUE__CONN_STR";
                      valueFrom.secretKeyRef = {
                        name = "forgejo-secrets";
                        key = "valkey-url";
                      };
                    }
                  ];
                };
                service = {
                  http = {
                    type = "LoadBalancer";
                    loadBalancerIP = "192.168.1.204";
                    annotations = {
                      "metallb.io/address-pool" = "default";
                      "metallb.io/allow-shared-ip" = "forgejo";
                    };
                  };
                  ssh = {
                    type = "LoadBalancer";
                    loadBalancerIP = "192.168.1.204";
                    annotations = {
                      "metallb.io/address-pool" = "default";
                      "metallb.io/allow-shared-ip" = "forgejo";
                    };
                  };
                };
                persistence = {
                  enabled = true;
                  size = "25Gi";
                };
                resources = {
                  requests.cpu = "50m";
                  requests.memory = "256Mi";
                  limits.cpu = "300m";
                  limits.memory = "512Mi";
                };
              };
              extraDeploy = [
                {
                  apiVersion = "postgresql.cnpg.io/v1";
                  kind = "Cluster";
                  metadata = {
                    namespace = "forgejo";
                    name = "forgejo-postgres";
                  };
                  spec = {
                    instances = 1;
                    imageCatalogRef = {
                      apiGroup = "postgresql.cnpg.io";
                      kind = "ClusterImageCatalog";
                      name = "postgresql-global";
                      major = 18;
                    };
                    storage.size = "8Gi";
                    managed.roles = [
                      {
                        name = "forgejo";
                        passwordSecret.name = "forgejo-secrets";
                        login = true;
                      }
                    ];
                    bootstrap.initdb = {
                      database = "forgejo";
                      owner = "forgejo";
                      secret.name = "forgejo-secrets";
                    };
                    resources = {
                      requests.cpu = "50m";
                      requests.memory = "256Mi";
                      limits.cpu = "300m";
                      limits.memory = "512Mi";
                    };
                  };
                }
                {
                  apiVersion = "v1";
                  kind = "Service";
                  metadata = {
                    name = "forgejo-tailscale";
                    namespace = "forgejo";
                    annotations = {
                      "tailscale.com/expose" = "true";
                      "tailscale.com/hostname" = "forgejo";
                    };
                  };
                  spec = {
                    type = "ClusterIP";
                    selector = {
                      "app.kubernetes.io/name" = "forgejo";
                      "app.kubernetes.io/instance" = "forgejo";
                      "app" = "forgejo";
                    };
                    ports = [
                      {
                        name = "http";
                        port = 80;
                        targetPort = 3000;
                        protocol = "TCP";
                      }
                      {
                        name = "ssh";
                        port = 22;
                        targetPort = 2222;
                        protocol = "TCP";
                      }
                    ];
                  };
                }
              ];
            };
          };
        })
        (lib.mkIf (config.forgejo.enable && config.secrets.enable && config.secrets.forgejo.enable) {
          sops = {
            secrets = {
              "forgejo/username" = { };
              "forgejo/password" = { };
              "forgejo/email" = { };
              "forgejo/key" = { };
              "forgejo/postgres_password" = { };
              "forgejo/valkey_password" = { };
            };
            templates = {
              forgejoSecrets = {
                content = builtins.toJSON {
                  apiVersion = "v1";
                  kind = "Secret";
                  type = "Opaque";
                  metadata = {
                    name = "forgejo-secrets";
                    namespace = "forgejo";
                  };
                  stringData = {
                    username = "forgejo";
                    password = config.sops.placeholder."forgejo/postgres_password";
                    valkey-password = config.sops.placeholder."forgejo/valkey_password";
                    valkey-url = "redis://default:${
                      config.sops.placeholder."forgejo/valkey_password"
                    }@forgejo-valkey:6379/0";
                  };
                };
                path = "/var/lib/rancher/k3s/server/manifests/forgejo-secret.json";
              };
              forgejoAdminSecrets = {
                content = builtins.toJSON {
                  apiVersion = "v1";
                  kind = "Secret";
                  type = "Opaque";
                  metadata = {
                    name = "forgejo-admin-secrets";
                    namespace = "forgejo";
                  };
                  stringData = {
                    username = config.sops.placeholder."forgejo/username";
                    password = config.sops.placeholder."forgejo/password";
                    email = config.sops.placeholder."forgejo/email";
                  };
                };
                path = "/var/lib/rancher/k3s/server/manifests/forgejo-admin-secret.json";
              };
            };
          };
        })
      ];
    };
}
