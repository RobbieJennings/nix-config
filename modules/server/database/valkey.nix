{
  self,
  inputs,
  ...
}:
{
  config.flake.factory.valkey =
    {
      namespace,
      values,
    }:
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      chart = {
        name = "valkey";
        repo = "https://valkey.io/valkey-helm";
        version = "0.9.3";
        hash = "sha256-Ig2kNNiZka/DUSBHQB7fZq/+9sf6hrUeBveNolbxDvw=";
      };
      image = pkgs.dockerTools.pullImage {
        imageName = "valkey/valkey";
        imageDigest = "sha256:546304417feac0874c3dd576e0952c6bb8f06bb4093ea0c9ca303c73cf458f63";
        sha256 = "sha256-Fytwh9dNSRODr0ZsSaqIXGppqVF424C2TW47Uiv0ZWA=";
        finalImageTag = "9.0.1";
        arch = "amd64";
      };
    in
    {
      config = {
        services.k3s = {
          images = [ image ];
          autoDeployCharts = {
            "${namespace}-valkey" = chart // {
              targetNamespace = namespace;
              createNamespace = true;
              values = values // {
                image = {
                  repository = image.imageName;
                  tag = image.imageTag;
                };
              };
            };
          };
        };
      };
    };
}
