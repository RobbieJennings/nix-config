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
      devShells = {
        default = pkgs.mkShell {
          inherit (self'.checks.pre-commit-check) shellHook;
          buildInputs = self'.checks.pre-commit-check.enabledPackages;
        };
      };
    };
}
