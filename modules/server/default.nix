{
  inputs,
  ...
}:
{
  flake.modules.nixos.server =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.k3s
        inputs.self.modules.nixos.longhorn
        inputs.self.modules.nixos.metallb
        inputs.self.modules.nixos.nextcloud
        inputs.self.modules.nixos.gitea
        inputs.self.modules.nixos.homepage
        inputs.self.modules.nixos.media-server
      ];

      config = {
        k3s.enable = lib.mkDefault true;
        longhorn.enable = lib.mkDefault true;
        metallb.enable = lib.mkDefault true;
        nextcloud.enable = lib.mkDefault true;
        gitea.enable = lib.mkDefault true;
        homepage.enable = lib.mkDefault true;
        media-server.enable = lib.mkDefault true;
      };
    };
}
