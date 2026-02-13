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
            nixfmt-rfc-style.enable = true;
            flake-checker.enable = true;
            statix.enable = true;
            nil.enable = true;
          };
        };
      };
    };
}
