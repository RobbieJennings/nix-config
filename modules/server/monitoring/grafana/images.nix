{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.grafana-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      grafanaImages = {
        grafanaImage = pkgs.dockerTools.pullImage {
          imageName = "grafana/grafana";
          imageDigest = "sha256:dbbc38ea21103cefb50396340cd88afec779c7e070b0a7bf5a75b4ce46651d3f";
          hash = "sha256-vbrydmVBoYGYHKCeQwNZHifLxIpA3xsU5ObjmbunJhY=";
          finalImageTag = "13.2.4";
          arch = "amd64";
        };
      };
    in
    {
      config = {
        _module.args.grafanaImages = grafanaImages;
        services.k3s = lib.mkIf config.monitoring.grafana.enable {
          images = builtins.attrValues grafanaImages;
        };
      };
    };
}
