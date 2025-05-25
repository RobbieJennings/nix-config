{ config, lib, pkgs, inputs, ... }:

{
  options = {
    server.longhorn.enable =
      lib.mkEnableOption "deploys longhorn helm chart on k3s";
  };

  config = lib.mkIf config.server.longhorn.enable {
    services.k3s = {
      autoDeployCharts.longhorn = {
        name = "longhorn";
        repo = "https://charts.longhorn.io";
        version = "1.8.1";
        hash = "sha256-cc3U1SSSb8LxWHAzSAz5d97rTfL7cDfxc+qOjm8c3CA=";
        createNamespace = true;
        targetNamespace = "longhorn-system";
        values = {

        };
        extraDeploy = [
          {
            apiVersion = "networking.k8s.io/v1";
            kind = "Ingress";
            metadata = {
              name = "longhorn";
              annotations."traefik.ingress.kubernetes.io/router.middlewares" =
                "default-longhorn-strip-prefix@kubernetescrd";
            };
            spec = {
              ingressClassName = "traefik";
              rules = [
                {
                  http.paths = [
                    {
                      path = "/longhorn";
                      pathType = "Exact";
                      backend.service = {
                        name = "longhorn";
                        port.number = 80;
                      };
                    }
                  ];
                }
              ];
            };
          }
          {
            apiVersion = "traefik.io/v1alpha1";
            kind = "Middleware";
            metadata.name = "longhorn-strip-prefix";
            spec.stripPrefix.prefixes = [ "/longhorn" ];
          }
        ];
      };
    };
  };
}
