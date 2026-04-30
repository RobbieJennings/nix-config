{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.homepage-homepage-widgets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.homepage.enable {
        services.k3s.manifests.homepage.content = [
          {
            apiVersion = "v1";
            kind = "ConfigMap";
            metadata = {
              name = "homepage-widgets";
              namespace = "homepage";
            };
            data."widgets.yaml" = builtins.toJSON [
              {
                resources = {
                  label = "System";
                  uptime = true;
                  cputemp = true;
                  cpu = true;
                  memory = true;
                  tempmin = 0;
                  tempmax = 100;
                };
              }
              {
                longhorn = {
                  url = "http://192.168.1.201";
                  expanded = true;
                  total = true;
                  labels = true;
                  nodes = true;
                };
              }
              {
                search = {
                  provider = "google";
                  focus = true;
                  showSearchSuggestions = true;
                  target = "_blank";
                };
              }
            ];
          }
        ];
      };
    };
}
