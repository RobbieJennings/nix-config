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
        imageDigest = "sha256:191d4fdfb7264f16989f0a57f320872620a5a7c2ceeec6229212c4190ec49b86";
        hash = "sha256-Vp6LlgV8NjQh9EwL4EXC/bAv6mrdjD2AbEXvv+X+Xrc=";
        finalImageTag = "3.7.2";
        arch = "amd64";
      };
      lokiCanaryImage = pkgs.dockerTools.pullImage {
        imageName = "grafana/loki-canary";
        imageDigest = "sha256:93751140d6c5cdfb3b07587b10ff262861c9b86c0f2935a418b12e0407cf0d0f";
        hash = "sha256-I8MAuw5hfKc0o7bGLINYY2SVXAxFeaF9ee0gIJc3Q1g=";
        finalImageTag = "3.7.2";
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
