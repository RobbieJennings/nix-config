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
      grafanaImage = pkgs.dockerTools.pullImage {
        imageName = "grafana/grafana";
        imageDigest = "sha256:dbbc38ea21103cefb50396340cd88afec779c7e070b0a7bf5a75b4ce46651d3f";
        hash = "sha256-vbrydmVBoYGYHKCeQwNZHifLxIpA3xsU5ObjmbunJhY=";
        finalImageTag = "13.2.4";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.monitoring.grafana.enable {
        services.k3s.images = [ grafanaImage ];
      };
    };
}
