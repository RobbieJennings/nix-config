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
        version = "0.2.0";
        hash = "sha256-LWZSYmAuxj8hfWEmyllYRNUMRBKSw5lSEU4C8B2fGV0=";
      };
      operatorImage = pkgs.dockerTools.pullImage {
        imageName = "ghcr.io/valkey-io/valkey-operator";
        imageDigest = "sha256:af108f6e9a5647271796c4d2f41ec9336c60b8da74cd2f106daf1157e7a521a2";
        hash = "sha256-cLuf0OzIteu/oN4rxvUmHJOXphBZOal7VfQtWr7gqik=";
        finalImageTag = "v0.2.0";
        arch = "amd64";
      };
      valkeyImage = pkgs.dockerTools.pullImage {
        imageName = "valkey/valkey";
        imageDigest = "sha256:546304417feac0874c3dd576e0952c6bb8f06bb4093ea0c9ca303c73cf458f63";
        hash = "sha256-Fytwh9dNSRODr0ZsSaqIXGppqVF424C2TW47Uiv0ZWA=";
        finalImageTag = "9.0.1";
        arch = "amd64";
      };
      exporterImage = pkgs.dockerTools.pullImage {
        imageName = "oliver006/redis_exporter";
        imageDigest = "sha256:cd5fad1591e585db5b58beec7fca427027c61a4349f50109af67cf2f07964d02";
        hash = "sha256-z7B3zFmyp2SizMZcHEw0A6qEVTeC6ARuoJJ7aSncpfY=";
        finalImageTag = "v1.80.0";
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
