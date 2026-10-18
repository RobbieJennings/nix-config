{
  inputs,
  ...
}:
{
  flake.modules.nixos.valkey-operator =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      chart = {
        name = "valkey-operator";
        repo = "https://valkey.io/valkey-helm";
        version = "0.7.0";
        hash = "sha256-EbBMwxR4AXmwAewS2E4rtCIguAgAkyq3ethoysZ79i0=";
      };
      operatorImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/valkey-io/valkey-operator";
        imageDigest = "sha256:bfa3be0b1173b64c94ad0ffd26282d9b5c392c4548a4bec379d715c7085ce120";
        hash = "sha256-MhotKM9IRTs1ZzmqepNgzg2r9PPZn9WUw63fSkiElFM=";
        finalImageTag = "v0.7.1";
        arch = "amd64";
      };
      valkeyImage = pkgs.dockerTools.pullImage {
        imageName = "valkey/valkey";
        imageDigest = "sha256:418652cfb58ef879d4978c33553735d7147016032d5aefaa14c828e611eb9dfd";
        hash = "sha256-AvNRZ8yuT3fqBx2PVJBFjsUq0WApHWn2kFC96U4sofc=";
        finalImageTag = "9.1.2";
        arch = "amd64";
      };
      exporterImage = pkgs.dockerTools.pullImage {
        imageName = "oliver006/redis_exporter";
        imageDigest = "sha256:0842ef7110e62b40bbde2d5c11f38c6fbd99f7100c75e3866637c1b335a1eff7";
        hash = "sha256-OGq22ZmasEMRuHWhppvvS5m/W5OnGIwDYIjoVEZl7Wg=";
        finalImageTag = "v1.94.0";
        arch = "amd64";
      };
    in
    {
      options = {
        valkey-operator.enable = lib.mkEnableOption "valkey-operator helm chart on k3s";
      };

      config = lib.mkIf config.valkey-operator.enable {
        services.k3s = {
          images = [
            operatorImage
            valkeyImage
            exporterImage
          ];
          autoDeployCharts = {
            valkey-operator = chart // {
              targetNamespace = "valkey-operator-system";
              createNamespace = true;
              values = {
                image = {
                  repository = operatorImage.imageName;
                  tag = operatorImage.imageTag;
                };
                resources = config.server.resources.profiles.infraLarge;
              };
            };
          };
        };
      };
    };
}
