{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.loki-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      lokiImage = pkgs.dockerTools.pullImage {
        imageName = "grafana/loki";
        imageDigest = "sha256:1107dd5274e0ada47e42472b7a7e71f3b2a2fe878878108f3e2f9e51528f0193";
        hash = "sha256-raRYP48Zbt9/rxxgnAt89ioWx5T6JOUeECW3IXHYR98=";
        finalImageTag = "3.7.8";
        arch = "amd64";
      };
      lokiCanaryImage = pkgs.dockerTools.pullImage {
        imageName = "grafana/loki-canary";
        imageDigest = "sha256:5619fbc071c5fc04825e947e55d87458aac0b22e96b8e893e4ab8dd17d2cf735";
        hash = "sha256-ORjj16NpzPauWTcK2vzQQgSGPh1Xgk7EgU9IlIwWRC4=";
        finalImageTag = "3.7.8";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.monitoring.loki.enable {
        services.k3s = {
          images = [
            lokiImage
            lokiCanaryImage
          ];
        };
      };
    };
}
