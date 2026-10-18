{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.prometheus-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      prometheusImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/prometheus/prometheus";
        imageDigest = "sha256:b2a413d5a03ea6a76782a508d1c7947440bba3b973931a25676e278431891b01";
        hash = "sha256-vtY2BUBiPZbW05yqnDncYLy4t9S7+M/xW9kHHgy+H9s=";
        finalImageTag = "v3.15.0-distroless";
        arch = "amd64";
      };
      alertmanagerImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/prometheus/alertmanager";
        imageDigest = "sha256:e9733bafb1bdef9b00e25a21f8f99dc26a22224bf16641ad754d1649f4c3357a";
        hash = "sha256-2zicb4HPcfHdN0Cx1BXvRADGCrA7qL5w0XjoxuP+Rmc=";
        finalImageTag = "v0.34.1";
        arch = "amd64";
      };
      nodeExporterImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/prometheus/node-exporter";
        imageDigest = "sha256:1b4e4438faca4dd7e001dd445d161a4a2091b0fededa84093b3a8dfeae1f1be0";
        hash = "sha256-e+TLRHo1P9iHagwM6nOiLvCS+I3WisEcUJhp/XN7zTA=";
        finalImageTag = "v1.12.1";
        arch = "amd64";
      };
      kubeStateMetricsImage = pkgs.dockerTools.pullImage {
        imageName = "registry.k8s.io/kube-state-metrics/kube-state-metrics";
        imageDigest = "sha256:42cfe3723a5f058171c627537fb57a3ea0f26e4380fa18555a95cb1a1b4cfc5b";
        hash = "sha256-zOoIuPRb20ooHG8Np/kN0SjYagvvVTCukGZ0jaO7O8k=";
        finalImageTag = "v2.20.0";
        arch = "amd64";
      };
      prometheusOperatorImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/prometheus-operator/prometheus-operator";
        imageDigest = "sha256:7c88d4e7bae63bd8d0f8da986054337c23b4472fa8d3c6817f5bc4b8407a2d6a";
        hash = "sha256-KQTsBMu1bXT2VnTzRU+aADslcsua+UtVE/cAx8Cm984=";
        finalImageTag = "v0.94.1";
        arch = "amd64";
      };
      prometheusConfigReloaderImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/prometheus-operator/prometheus-config-reloader";
        imageDigest = "sha256:06b52bd4dbe3ed6dd5905aadaf8b9987d9da4c31d37bb86deaadae68cee2d26b";
        hash = "sha256-x/OTka/LLjdFtRNrh6oLphBU5reEAAinUTvYafw/kf8=";
        finalImageTag = "v0.94.1";
        arch = "amd64";
      };
      thanosImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/thanos/thanos";
        imageDigest = "sha256:b567818fe608067eb0f1d7c2c4fe361e7ad83c8a256234c97685f1d0bf670cc8";
        hash = "sha256-T1ph9yDUFmSV09j2jRh8ehzQ65jxD3xVytfoba89zxE=";
        finalImageTag = "v0.42.4";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.monitoring.prometheus.enable {
        services.k3s = {
          images = [
            prometheusImage
            alertmanagerImage
            nodeExporterImage
            kubeStateMetricsImage
            prometheusOperatorImage
            prometheusConfigReloaderImage
            thanosImage
          ];
        };
      };
    };
}
