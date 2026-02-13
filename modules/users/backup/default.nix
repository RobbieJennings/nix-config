{
  inputs,
  ...
}:
{
  flake.modules.homeManager.backup =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.homeManager.rclone
        inputs.self.modules.homeManager.restic
      ];

      config = {
        restic.enable = lib.mkDefault true;
        rclone.enable = lib.mkDefault true;
      };
    };
}
