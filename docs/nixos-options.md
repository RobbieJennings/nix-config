## audio\.enable

Whether to enable audio using pipewire\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/desktop/audio\.nix](../modules/desktop/audio.nix)



## auto-upgrade\.enable



Whether to enable automatic update of nix flake from github\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/core/auto-upgrade\.nix](../modules/core/auto-upgrade.nix)



## bluetooth\.enable



Whether to enable bluetooth\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/desktop/bluetooth\.nix](../modules/desktop/bluetooth.nix)



## bootloader\.enable



Whether to enable systemd-boot bootloader\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/core/bootloader\.nix](../modules/core/bootloader.nix)



## bootloader\.pretty



Whether to enable silent boot with plymouth\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/core/bootloader\.nix](../modules/core/bootloader.nix)



## cosmic-desktop\.enable



Whether to enable cosmic desktop environment\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/desktop/cosmic-desktop\.nix](../modules/desktop/cosmic-desktop.nix)



## docker\.enable



Whether to enable docker\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/core/docker\.nix](../modules/core/docker.nix)



## garbage-collection\.enable



Whether to enable automatic garbage collection of nix store\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/core/gargabe-collection\.nix](../modules/core/gargabe-collection.nix)



## gitea\.enable



Whether to enable Gitea Helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/gitea\.nix](../modules/server/gitea.nix)



## hello-world\.enable



Whether to enable hello world helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/hello-world\.nix](../modules/server/hello-world.nix)



## impermanence\.enable



Whether to enable impermanence\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/core/impermanence\.nix](../modules/core/impermanence.nix)



## k3s\.enable



Whether to enable k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/k3s\.nix](../modules/server/k3s.nix)



## kde-connect\.enable



Whether to enable kde connect phone pairing app\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/desktop/kde-connect\.nix](../modules/desktop/kde-connect.nix)



## kde-plasma\.enable



Whether to enable kde plasma desktop environment\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/desktop/kde-plasma\.nix](../modules/desktop/kde-plasma.nix)



## localisation\.enable



Whether to enable localisation settings for Dublin\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/core/localisation\.nix](../modules/core/localisation.nix)



## longhorn\.enable



Whether to enable longhorn helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/longhorn\.nix](../modules/server/longhorn.nix)



## media-server\.enable



Whether to enable jellyfin, transmission and servarr services on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/media/default\.nix](../modules/server/media/default.nix)



## media-server\.flaresolverr\.enable



Whether to enable FlareSolverr for Prowlarr\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/media/flaresolverr\.nix](../modules/server/media/flaresolverr.nix)



## media-server\.jellyfin\.enable



Whether to enable jellyfin helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/media/jellyfin\.nix](../modules/server/media/jellyfin.nix)



## media-server\.lidarr\.enable



Whether to enable lidarr manifest on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/media/lidarr\.nix](../modules/server/media/lidarr.nix)



## media-server\.prowlarr\.enable



Whether to enable prowlarr manifest on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/media/prowlarr\.nix](../modules/server/media/prowlarr.nix)



## media-server\.radarr\.enable



Whether to enable radarr manifest on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/media/radarr\.nix](../modules/server/media/radarr.nix)



## media-server\.sonarr\.enable



Whether to enable sonarr manifest on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/media/sonarr\.nix](../modules/server/media/sonarr.nix)



## media-server\.transmission\.enable



Whether to enable transmission manifest on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/media/transmission\.nix](../modules/server/media/transmission.nix)



## metallb\.enable



Whether to enable metalLB helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/metallb\.nix](../modules/server/metallb.nix)



## networking\.enable



Whether to enable networking using networkmanager\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/core/networking\.nix](../modules/core/networking.nix)



## nextcloud\.enable



Whether to enable nextcloud helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/nextcloud\.nix](../modules/server/nextcloud.nix)



## printing\.enable



Whether to enable printing using CUPS\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/desktop/printing\.nix](../modules/desktop/printing.nix)



## scanning\.enable



Whether to enable scanning using SANE and installs necessary drivers for Epson Perfection V550 Scanner\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/desktop/scanning\.nix](../modules/desktop/scanning.nix)



## secrets\.enable



Whether to enable importing secrets using sops-nix\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/core/secrets\.nix](../modules/core/secrets.nix)



## secrets\.k3s\.enable



Whether to enable k3s token secret\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/k3s\.nix](../modules/server/k3s.nix)



## secrets\.passwords\.enable



Whether to enable user password secrets\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/core/secrets\.nix](../modules/core/secrets.nix)



## steam\.enable



Whether to enable steam gaming client\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/desktop/steam\.nix](../modules/desktop/steam.nix)



## theme\.enable



Whether to enable stylix theme\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.base16Scheme



tinted theming colour scheme



*Type:*
string



*Default:*
` "default-dark" `



*Example:*
` "catppuccin-mocha" `

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.fonts



Fonts used for interface, terminal and emojis



*Type:*
submodule



*Default:*
` { } `

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.fonts\.emoji



The font to use for emoji



*Type:*
submodule



*Default:*
` Noto Color Emoji `

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.fonts\.emoji\.package



package to use for the emoji font



*Type:*
package

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.fonts\.emoji\.name



The name to use for the emoji font



*Type:*
string

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.fonts\.interface



The font to use for the interface



*Type:*
submodule



*Default:*
` Inter `

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.fonts\.interface\.package



package to use for the interface font



*Type:*
package

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.fonts\.interface\.name



The name to use for the interface font



*Type:*
string

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.fonts\.monospace



The font to use for the terminal



*Type:*
submodule



*Default:*
` JetBrainsMono Nerd Font Mono `

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.fonts\.monospace\.package



package to use for the monospace font



*Type:*
package

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.fonts\.monospace\.name



The name to use for the monospace font



*Type:*
string

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.image



Custom source with URL and hash



*Type:*
submodule



*Default:*

```
{
  hash = "sha256-JaLHdBxwrphKVherDVe5fgh+3zqUtpcwuNbjwrBlAok=";
  url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nix-wallpaper-simple-dark-gray.png";
}
```

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.image\.hash



SHA256 hash in SRI format



*Type:*
string

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.image\.url



Download URL



*Type:*
string

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.polarity



light or dark theme



*Type:*
one of “light”, “dark”



*Default:*
` "dark" `

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## virtualisation\.enable



Whether to enable virtualisation using libvirt \& qemu\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/desktop/virtualisation\.nix](../modules/desktop/virtualisation.nix)



## zsh\.enable



Whether to enable zsh\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/core/zsh\.nix](../modules/core/zsh.nix)


