{
  inputs,
  ...
}:
{
  flake.modules.nixos.audio =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        audio.enable = lib.mkEnableOption "audio using pipewire";
      };

      config = lib.mkIf config.audio.enable {
        services.pipewire = {
          enable = true;
          pulse.enable = lib.mkDefault true;
        };
      };
    };
}
