## auto-upgrade\.enable

Whether to enable automatic update of nix flake from github\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/core/auto-upgrade\.nix](../modules/nixos/core/auto-upgrade.nix)



## bootloader\.enable



Whether to enable systemd-boot bootloader\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/core/bootloader\.nix](../modules/nixos/core/bootloader.nix)



## bootloader\.pretty



Whether to enable silent boot with plymouth\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/core/bootloader\.nix](../modules/nixos/core/bootloader.nix)



## desktop\.enable



Whether to enable default desktop modules\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/desktop](../modules/nixos/desktop)



## desktop\.audio\.enable



Whether to enable audio using pipewire\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/desktop/audio\.nix](../modules/nixos/desktop/audio.nix)



## desktop\.bluetooth\.enable



Whether to enable bluetooth\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/desktop/bluetooth\.nix](../modules/nixos/desktop/bluetooth.nix)



## desktop\.cosmic-desktop\.enable



Whether to enable cosmic desktop environment\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/desktop/cosmic-desktop\.nix](../modules/nixos/desktop/cosmic-desktop.nix)



## desktop\.kde-connect\.enable



Whether to enable kde connect phone pairing app\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/desktop/kde-connect\.nix](../modules/nixos/desktop/kde-connect.nix)



## desktop\.kde-plasma\.enable



Whether to enable kde plasma desktop environment\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/desktop/kde-plasma\.nix](../modules/nixos/desktop/kde-plasma.nix)



## desktop\.printing\.enable



Whether to enable printing using CUPS\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/desktop/printing\.nix](../modules/nixos/desktop/printing.nix)



## desktop\.scanning\.enable



Whether to enable scanning using SANE and installs necessary drivers for Epson Perfection V550 Scanner\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/desktop/scanning\.nix](../modules/nixos/desktop/scanning.nix)



## desktop\.steam\.enable



Whether to enable steam gaming client\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/desktop/steam\.nix](../modules/nixos/desktop/steam.nix)



## desktop\.virtualisation\.enable



Whether to enable virtualisation using libvirt \& qemu\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/desktop/virtualisation\.nix](../modules/nixos/desktop/virtualisation.nix)



## docker\.enable



Whether to enable docker\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/core/docker\.nix](../modules/nixos/core/docker.nix)



## garbage-collection\.enable



Whether to enable automatic garbage collection of nix store\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/core/garbage-collection\.nix](../modules/nixos/core/garbage-collection.nix)



## impermanence\.enable



Whether to enable impermanence\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/core/impermanence\.nix](../modules/nixos/core/impermanence.nix)



## localisation\.enable



Whether to enable localisation settings for Dublin\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/core/localisation\.nix](../modules/nixos/core/localisation.nix)



## networking\.enable



Whether to enable networking using networkmanager\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/core/networking\.nix](../modules/nixos/core/networking.nix)



## secrets\.enable



Whether to enable importing secrets using sops-nix\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/core/secrets\.nix](../modules/nixos/core/secrets.nix)



## secrets\.kubernetes\.enable



Whether to enable k3s token secret\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/server/kubernetes\.nix](../modules/nixos/server/kubernetes.nix)



## secrets\.passwords\.enable



Whether to enable user password secrets\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/core/secrets\.nix](../modules/nixos/core/secrets.nix)



## server\.enable



Whether to enable default server modules\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/server](../modules/nixos/server)



## server\.hello-world\.enable



Whether to enable hello world helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/server/hello-world\.nix](../modules/nixos/server/hello-world.nix)



## server\.kubernetes\.enable



Whether to enable k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/server/kubernetes\.nix](../modules/nixos/server/kubernetes.nix)



## server\.longhorn\.enable



Whether to enable longhorn helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/server/longhorn\.nix](../modules/nixos/server/longhorn.nix)



## server\.media\.enable



Whether to enable jellyfin, transmission and servarr services on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/server/media](../modules/nixos/server/media)



## server\.media\.flaresolverr\.enable



Whether to enable FlareSolverr for Prowlarr\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/server/media/flaresolverr\.nix](../modules/nixos/server/media/flaresolverr.nix)



## server\.media\.jellyfin\.enable



Whether to enable jellyfin helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/server/media/jellyfin\.nix](../modules/nixos/server/media/jellyfin.nix)



## server\.media\.lidarr\.enable



Whether to enable lidarr manifest on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/server/media/lidarr\.nix](../modules/nixos/server/media/lidarr.nix)



## server\.media\.prowlarr\.enable



Whether to enable prowlarr manifest on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/server/media/prowlarr\.nix](../modules/nixos/server/media/prowlarr.nix)



## server\.media\.radarr\.enable



Whether to enable radarr manifest on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/server/media/radarr\.nix](../modules/nixos/server/media/radarr.nix)



## server\.media\.sonarr\.enable



Whether to enable sonarr manifest on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/server/media/sonarr\.nix](../modules/nixos/server/media/sonarr.nix)



## server\.media\.transmission\.enable



Whether to enable transmission manifest on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/server/media/transmission\.nix](../modules/nixos/server/media/transmission.nix)



## server\.metallb\.enable



Whether to enable metalLB helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/server/metallb\.nix](../modules/nixos/server/metallb.nix)



## theme\.enable



Whether to enable stylix theme\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/core/theme\.nix](../modules/nixos/core/theme.nix)



## theme\.base16Scheme



tinted theming colour scheme



*Type:*
string



*Default:*
` "default-dark" `



*Example:*
` "catppuccin-mocha" `

*Declared by:*
 - [modules/nixos/core/theme\.nix](../modules/nixos/core/theme.nix)



## theme\.fonts



Fonts used for interface, terminal and emojis



*Type:*
submodule



*Default:*
` { } `

*Declared by:*
 - [modules/nixos/core/theme\.nix](../modules/nixos/core/theme.nix)



## theme\.fonts\.emoji



The font to use for emoji



*Type:*
submodule



*Default:*
` Noto Color Emoji `

*Declared by:*
 - [modules/nixos/core/theme\.nix](../modules/nixos/core/theme.nix)



## theme\.fonts\.emoji\.package



package to use for the emoji font



*Type:*
package

*Declared by:*
 - [modules/nixos/core/theme\.nix](../modules/nixos/core/theme.nix)



## theme\.fonts\.emoji\.name



The name to use for the emoji font



*Type:*
string

*Declared by:*
 - [modules/nixos/core/theme\.nix](../modules/nixos/core/theme.nix)



## theme\.fonts\.interface



The font to use for the interface



*Type:*
submodule



*Default:*
` Inter `

*Declared by:*
 - [modules/nixos/core/theme\.nix](../modules/nixos/core/theme.nix)



## theme\.fonts\.interface\.package



package to use for the interface font



*Type:*
package

*Declared by:*
 - [modules/nixos/core/theme\.nix](../modules/nixos/core/theme.nix)



## theme\.fonts\.interface\.name



The name to use for the interface font



*Type:*
string

*Declared by:*
 - [modules/nixos/core/theme\.nix](../modules/nixos/core/theme.nix)



## theme\.fonts\.monospace



The font to use for the terminal



*Type:*
submodule



*Default:*
` JetBrainsMono Nerd Font Mono `

*Declared by:*
 - [modules/nixos/core/theme\.nix](../modules/nixos/core/theme.nix)



## theme\.fonts\.monospace\.package



package to use for the monospace font



*Type:*
package

*Declared by:*
 - [modules/nixos/core/theme\.nix](../modules/nixos/core/theme.nix)



## theme\.fonts\.monospace\.name



The name to use for the monospace font



*Type:*
string

*Declared by:*
 - [modules/nixos/core/theme\.nix](../modules/nixos/core/theme.nix)



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
 - [modules/nixos/core/theme\.nix](../modules/nixos/core/theme.nix)



## theme\.image\.hash



SHA256 hash in SRI format



*Type:*
string

*Declared by:*
 - [modules/nixos/core/theme\.nix](../modules/nixos/core/theme.nix)



## theme\.image\.url



Download URL



*Type:*
string

*Declared by:*
 - [modules/nixos/core/theme\.nix](../modules/nixos/core/theme.nix)



## theme\.polarity



light or dark theme



*Type:*
one of “light”, “dark”



*Default:*
` "dark" `

*Declared by:*
 - [modules/nixos/core/theme\.nix](../modules/nixos/core/theme.nix)



## zsh\.enable



Whether to enable zsh\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/core/zsh\.nix](../modules/nixos/core/zsh.nix)


