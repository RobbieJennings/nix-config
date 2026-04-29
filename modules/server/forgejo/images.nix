{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.forgejo-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      forgejoImage = pkgs.dockerTools.pullImage {
        imageName = "code.forgejo.org/forgejo/forgejo";
        imageDigest = "sha256:bca6943cdd8a50f5befaf1d654bec32c9a3b6da400d23a77a829bd41f88a7263";
        sha256 = "sha256-LGR+YFcOnsL0Bt6O/ABxULKTKbNjOoHEUdAJxN49IqI=";
        finalImageTag = "14.0.4-rootless";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.forgejo.enable {
        services.k3s = {
          images = [ forgejoImage ];
          autoDeployCharts.forgejo.values = {
            image = {
              registry = "code.forgejo.org";
              repository = "forgejo/forgejo";
              tag = forgejoImage.imageTag;
            };
          };
        };
      };
    };
}
