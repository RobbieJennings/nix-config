{
  inputs,
  ...
}:
{
  perSystem =
    {
      self',
      system,
      pkgs,
      ...
    }:
    {
      checks = {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ../../.;
          hooks = {
            nixfmt.enable = true;
            statix.enable = true;
            nil.enable = true;
          };
        };
      };
    };
}
