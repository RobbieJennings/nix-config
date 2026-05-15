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
        imageDigest = "sha256:cc2d74fb4c30385a8ee34de8c8f83344f7316cec70bd2cc7eb82b2802fa28e0b";
        hash = "sha256-9WflWFSAr3RDZ+mJ4+pgFldOabcSWRLOcfZ3DpxMlOM=";
        finalImageTag = "15.0.2-rootless";
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
