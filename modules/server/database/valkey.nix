# Factory module for use when valkey-cluster is not supported
# as operator cannot be used to deploy standalone valkey instances
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
    in
    {
      config = {
        services.k3s = {
          autoDeployCharts = {
            "${namespace}-valkey" = chart // {
              targetNamespace = namespace;
              createNamespace = true;
              values = values // {
                image =
                  let
                    image = inputs.self.lib.findImageByName "valkey/valkey" config.services.k3s.images;
                  in
                  values.image or {
                    repository = image.imageName;
                    tag = image.imageTag;
                  };
                resources = values.resources or config.server.resources.profiles.cache;
              };
            };
          };
        };
      };
    };
}
