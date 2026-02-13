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
      formatter = pkgs.nixfmt-tree;
    };
}
