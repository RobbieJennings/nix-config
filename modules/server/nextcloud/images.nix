{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.nextcloud-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      nextcloudImage = pkgs.dockerTools.pullImage {
        imageName = "nextcloud";
        imageDigest = "sha256:4d4a6b5ed15a7eb4537538c848eb78833f53bed62f93e7d5af144f360cd53ff2";
        hash = "sha256-+T0GwW1ep+4dTqHZ9a3h0Xby3uoykUrZXUZVTlYIZsw=";
        finalImageTag = "34.0.0";
        arch = "amd64";
      };
      collaboraImage = pkgs.dockerTools.pullImage {
        imageName = "collabora/code";
        imageDigest = "sha256:75859dc9f9084d1877ce36cf96ec86600f495bade33289c9cbc27e0a0ee23b81";
        hash = "sha256-sheTKqJ+zFU1CgY5BRknBRR849ruGOOa26E4d5u5HY8=";
        finalImageTag = "26.04.1.4.1";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.nextcloud.enable {
        services.k3s.images = [
          nextcloudImage
          collaboraImage
        ];
      };
    };
}
