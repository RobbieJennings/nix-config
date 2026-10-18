{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.freshrss-images =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      freshrss-image = pkgs.dockerTools.pullImage {
        imageName = "linuxserver/freshrss";
        imageDigest = "sha256:703a03364866dc3283d6b1d53c1eaf697de5a6c594bd4acb5367ec8631288808";
        hash = "sha256-oDAtCuowNzUoGg3uA2d9mjynqSXJqR3Sh+EZjeas8Qk=";
        finalImageTag = "1.30.1";
        arch = "amd64";
      };
    in
    {
      config = lib.mkIf config.freshrss.enable {
        services.k3s = {
          images = [ freshrss-image ];
        };
      };
    };
}
