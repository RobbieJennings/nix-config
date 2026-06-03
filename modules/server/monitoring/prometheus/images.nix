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
        imageDigest = "sha256:cff72a3f49918f41c4b5c8a6174dd8433036bebf7878120da538b3720ba3fa0d";
        hash = "sha256-EUD4CQxvNDj7y3Pnd8IFmUVRUfqUDgKsTi4N7wb/U3Q=";
        finalImageTag = "v3.11.3-distroless";
        arch = "amd64";
      };
      alertmanagerImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/prometheus/alertmanager";
        imageDigest = "sha256:51a825c2a40acc3e338fdd00d622e01ec090f72be2b3ea46be0839cd47a4d286";
        hash = "sha256-8PJkivSQX+WaoiKEvFqsvSNCQ5vhellrpYCcJ5IfuHk=";
        finalImageTag = "v0.32.1";
        arch = "amd64";
      };
      nodeExporterImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/prometheus/node-exporter";
        imageDigest = "sha256:0f422f62c15f154af8d8572b23d623aebfb10cec73a5c654d18f911f3f9df241";
        hash = "sha256-MibYIyKQksWUMlWKEHDbS7hrq0/UdBFOo1Q/7R46qFQ=";
        finalImageTag = "v1.11.1";
        arch = "amd64";
      };
      kubeStateMetricsImage = pkgs.dockerTools.pullImage {
        imageName = "registry.k8s.io/kube-state-metrics/kube-state-metrics";
        imageDigest = "sha256:1545919b72e3ae035454fc054131e8d0f14b42ef6fc5b2ad5c751cafa6b2130e";
        hash = "sha256-7zJYcxg+KQtO20erjX5y9X1ymZdNSaJC8jiGnvRiS+s=";
        finalImageTag = "v2.18.0";
        arch = "amd64";
      };
      prometheusOperatorImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/prometheus-operator/prometheus-operator";
        imageDigest = "sha256:52a6a92d915ea2fa94314748d99db7a94922e3fe63274f6182fc033b9126b573";
        hash = "sha256-WTPxcdvqDxvwQfKN8+Q097N928I+BO6Ko43HvCdKFYA=";
        finalImageTag = "v0.90.1";
        arch = "amd64";
      };
      prometheusConfigReloaderImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/prometheus-operator/prometheus-config-reloader";
        imageDigest = "sha256:693faa0b87243cddca2cffb13586e4e2778b0cdf319cb2e601ba7af3fd19ef7d";
        hash = "sha256-l9rlj2UzvPmlYyobF0lMeHjk3xh0oKvoHPvYNwDvCEE=";
        finalImageTag = "v0.90.1";
        arch = "amd64";
      };
      thanosImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/thanos/thanos";
        imageDigest = "sha256:cf3e9b292e4302ad4a4955b56379703aea39516607d382a57604a3d003c35d10";
        hash = "sha256-Xi5HJ76pqjw5f3xwfa2u4+9I9OYgHkKqkOr4orB0sao=";
        finalImageTag = "v0.41.0";
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
