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
        imageDigest = "sha256:f39df5334dee301b885f77e0ff1159f5d8a43bf9db518f885544594799a1e3c2";
        hash = "sha256-rzsuQBJrAHER7ZOdx3ydiqmYOh8GdMdx12hP/5g/yhc=";
        finalImageTag = "v3.12.0-distroless";
        arch = "amd64";
      };
      alertmanagerImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/prometheus/alertmanager";
        imageDigest = "sha256:af26fbe4dd1886ac0efd7bd55cd9027da262e105b137a376522b7c14c3626e4a";
        hash = "sha256-CxfHRy5GlkgwLyCNbn3Cp2UstMbd5rqEZIzO4HWJGLg=";
        finalImageTag = "v0.33.0";
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
        imageDigest = "sha256:85108987d044b18a098126732f98602df408888c0f7d456241f5abefb9744bc1";
        hash = "sha256-6tCa17VSUIp6M9+QHgza/EC2LiJC9k1gazQFWBf3AIQ=";
        finalImageTag = "v2.19.1";
        arch = "amd64";
      };
      prometheusOperatorImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/prometheus-operator/prometheus-operator";
        imageDigest = "sha256:3db296f8aca7b3abbcbb79afac165abfe08212ad54f4301c88f68f079ec9d9b7";
        hash = "sha256-6cfkc+pRzMtGxfgLJgs+IDRA850TFVfx9cTc7wdC7kA=";
        finalImageTag = "v0.92.0";
        arch = "amd64";
      };
      prometheusConfigReloaderImage = pkgs.dockerTools.pullImage {
        imageName = "quay.io/prometheus-operator/prometheus-config-reloader";
        imageDigest = "sha256:3c48ed36b8a6a73a0b11a6e90a194fabf4069e76f32a44fece174b4d64e8ab0f";
        hash = "sha256-4sQn+IVAVC6hMmPfucpQ+UCJRCB0W8Lkj/rOErGRXZE=";
        finalImageTag = "v0.92.0";
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
