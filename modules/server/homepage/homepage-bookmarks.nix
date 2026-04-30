{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.homepage-homepage-bookmarks =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.homepage.enable {
        services.k3s.manifests.homepage.content = [
          {
            apiVersion = "v1";
            kind = "ConfigMap";
            metadata = {
              name = "homepage-bookmarks";
              namespace = "homepage";
            };
            data."bookmarks.yaml" = builtins.toJSON [
              {
                Developer = [
                  {
                    Github = [
                      {
                        abbr = "GH";
                        href = "https://github.com/";
                        description = "Code hosting";
                      }
                    ];
                  }
                ];
              }
              {
                Entertainment = [
                  {
                    YouTube = [
                      {
                        abbr = "YT";
                        href = "https://youtube.com/";
                        description = "Video sharing";
                      }
                    ];
                  }
                ];
              }
              {
                Social = [
                  {
                    Reddit = [
                      {
                        abbr = "RE";
                        href = "https://reddit.com/";
                        description = "The front page of the internet";
                      }
                    ];
                  }
                ];
              }
            ];
          }
        ];
      };
    };
}
