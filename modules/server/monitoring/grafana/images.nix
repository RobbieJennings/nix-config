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
        imageDigest = "sha256:121a7a9ece6dc10b969f1f96eed64b4f07dfac0d0b8abc070f7cb83bbde86f63";
        hash = "sha256-W7Uux1EHVhlCN9TCb+nbUT+dp07siWkDZR+wR2LYlsA=";
        finalImageTag = "13.1.0";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.monitoring.grafana.enable {
        services.k3s.images = [ grafanaImage ];
      };
    };
}
