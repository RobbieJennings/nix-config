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
        imageDigest = "sha256:6554520f7574602100b7d6620c6ac5b18cec30325f823777497eac36234f5cf8";
        hash = "sha256-eQJ3tJ+NVSZNx9+l+AGBHD/sR/wKAWRepyJpBdkTU/Y=";
        finalImageTag = "17.0.0-rootless";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.forgejo.enable {
        services.k3s.images = [ forgejoImage ];
      };
    };
}
