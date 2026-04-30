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
        imageDigest = "sha256:146a6add37403d7f74aa17f52a849de9babf24f92890613cacf346e12a969efc";
        sha256 = "sha256-Wk3gOMI3ev2iminSM/UO3Dj8Do2TzMbT2VdX/FJ+1Gg=";
        finalImageTag = "3.6.5";
        arch = "amd64";
      };
      lokiCanaryImage = pkgs.dockerTools.pullImage {
        imageName = "grafana/loki-canary";
        imageDigest = "sha256:76ae2f73a7dbc71a66bb774315c1c0cb58176536127d9ac5364ce7e4405211cd";
        sha256 = "sha256-jbrnGJ5CKUPHSkpfXBFbLh6kYkwQmEZj/wvk/+KyKMI=";
        finalImageTag = "3.6.5";
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
