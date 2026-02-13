{
  inputs,
  ...
}:
{
  flake.modules.nixos.printing =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        printing.enable = lib.mkEnableOption "printing using CUPS";
      };

      config = lib.mkIf config.printing.enable {
        services.printing.enable = true;
      };
    };
}
