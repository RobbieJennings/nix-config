{ config, lib, pkgs, inputs, ... }:

{
  options = {
    server.jellyfin.enable =
      lib.mkEnableOption "deploys jellyfin helm chart on k3s";
  };

  config = lib.mkIf config.server.jellyfin.enable {
    services.k3s = {
      autoDeployCharts.jellyfin = {
        name = "jellyfin";
        repo = "https://jellyfin.github.io/jellyfin-helm";
        version = "2.3.0";
        hash = "sha256-6ZEHzD7GqLytHoyIYQFYcKlN4yXwwpK6ZikXR2iOvW8=";
        values = {

        };
        extraDeploy = [
          {
            apiVersion = "networking.k8s.io/v1";
            kind = "Ingress";
            metadata = {
              name = "jellyfin";
              annotations."traefik.ingress.kubernetes.io/router.middlewares" =
                "default-jellyfin-strip-prefix@kubernetescrd";
            };
            spec = {
              ingressClassName = "traefik";
              rules = [{
                http.paths = [{
                  path = "/jellyfin";
                  pathType = "Exact";
                  backend.service = {
                    name = "jellyfin";
                    port.number = 8096;
                  };
                }];
              }];
            };
          }
          {
            apiVersion = "traefik.io/v1alpha1";
            kind = "Middleware";
            metadata.name = "jellyfin-strip-prefix";
            spec.stripPrefix.prefixes = [ "/jellyfin" ];
          }
        ];
      };
    };
  };
}
