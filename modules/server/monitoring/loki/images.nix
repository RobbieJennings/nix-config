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
        imageDigest = "sha256:70b9f699fc9bb868b62f1cfd4f787dfa50242f1fd92e6089787d5d7daea75fe8";
        hash = "sha256-wxd/IIRcMw//EyT6jbeH35yPWfgRVLF1Mrsk4DOkxA8=";
        finalImageTag = "3.7.3";
        arch = "amd64";
      };
      lokiCanaryImage = pkgs.dockerTools.pullImage {
        imageName = "grafana/loki-canary";
        imageDigest = "sha256:8073c4a5cb70191f4ebf5481704b3a665a92c764de3f03e7f42578aa3b8c2e6a";
        hash = "sha256-uvjyxk4G67kmqzoYM5xP/ZFipCytfW7Aq4KP1FhOFZg=";
        finalImageTag = "3.7.3";
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
