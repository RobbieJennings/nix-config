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



## cert-manager\.enable



Whether to enable Cert-manager helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/cert-manager/default\.nix](../modules/server/cert-manager/default.nix)



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



## desktopEnvironment



Select desktop environment: Plasma or COSMIC\.



*Type:*
one of “plasma”, “cosmic”



*Default:*
` "plasma" `

*Declared by:*
 - [modules/desktop/default\.nix](../modules/desktop/default.nix)



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



## forgejo\.enable



Whether to enable forgejo helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/forgejo/default\.nix](../modules/server/forgejo/default.nix)



## fwupd\.enable



Whether to enable firmware update manager\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/core/fwupd\.nix](../modules/core/fwupd.nix)



## garbage-collection\.enable



Whether to enable automatic garbage collection of nix store\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/core/garbage-collection\.nix](../modules/core/garbage-collection.nix)



## homepage\.enable



Whether to enable Homepage deployment on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/homepage/default\.nix](../modules/server/homepage/default.nix)



## immich\.enable



Whether to enable Immich helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/immich/default\.nix](../modules/server/immich/default.nix)



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



## intel-device-plugins\.enable



Whether to enable Intel device plugins for kubernetes\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/intel-plugins/default\.nix](../modules/server/intel-plugins/default.nix)



## intel-device-plugins\.gpu\.enable



Whether to enable Intel GPU plugin for Kubernetes\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/intel-plugins/gpu-device-plugin\.nix](../modules/server/intel-plugins/gpu-device-plugin.nix)



## intel-device-plugins\.operator\.enable



Whether to enable Intel Device Plugins Operator\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/intel-plugins/device-plugins-operator\.nix](../modules/server/intel-plugins/device-plugins-operator.nix)



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



Whether to enable Longhorn helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/longhorn/default\.nix](../modules/server/longhorn/default.nix)



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



Whether to enable Jellyfin deployment on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/media/jellyfin/default\.nix](../modules/server/media/jellyfin/default.nix)



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



Whether to enable Metallb helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/metallb/default\.nix](../modules/server/metallb/default.nix)



## monitoring\.enable



Whether to enable prometheus, grafana and loki services on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/monitoring/default\.nix](../modules/server/monitoring/default.nix)



## monitoring\.alloy\.enable



Whether to enable Alloy helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/monitoring/alloy/default\.nix](../modules/server/monitoring/alloy/default.nix)



## monitoring\.grafana\.enable



Whether to enable Grafana helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/monitoring/grafana/default\.nix](../modules/server/monitoring/grafana/default.nix)



## monitoring\.loki\.enable



Whether to enable Loki helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/monitoring/loki/default\.nix](../modules/server/monitoring/loki/default.nix)



## monitoring\.prometheus\.enable



Whether to enable Prometheus helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/monitoring/prometheus/default\.nix](../modules/server/monitoring/prometheus/default.nix)



## netbird\.enable



Whether to enable netbird client daemon\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/core/netbird\.nix](../modules/core/netbird.nix)



## netbird-operator\.enable



Whether to enable Netbird operator helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/netbird-operator/default\.nix](../modules/server/netbird-operator/default.nix)



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
 - [modules/server/nextcloud/default\.nix](../modules/server/nextcloud/default.nix)



## node-feature-discovery\.enable



Whether to enable Node feature discovery helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/node-feature-discovery/default\.nix](../modules/server/node-feature-discovery/default.nix)



## postgres\.enable



Whether to enable Cloudnative-pg helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/database/postgres\.nix](../modules/server/database/postgres.nix)



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



## qmk\.enable



Whether to enable QMK keyboard configuration\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/desktop/qmk\.nix](../modules/desktop/qmk.nix)



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



## secrets\.forgejo\.enable



Whether to enable Forgejo secrets\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/forgejo/default\.nix](../modules/server/forgejo/default.nix)



## secrets\.grafana\.enable



Whether to enable Grafana secrets\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/monitoring/grafana/default\.nix](../modules/server/monitoring/grafana/default.nix)



## secrets\.homepage\.enable



Whether to enable Homepage secrets\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/homepage/default\.nix](../modules/server/homepage/default.nix)



## secrets\.immich\.enable



Whether to enable Immich secrets\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/immich/default\.nix](../modules/server/immich/default.nix)



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



## secrets\.media-server\.enable



Whether to enable jellyfin, transmission and servarr secrets\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/media/default\.nix](../modules/server/media/default.nix)



## secrets\.netbird-operator\.enable



Whether to enable SOPS-managed OAuth secret for Netbird operator\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/netbird-operator/default\.nix](../modules/server/netbird-operator/default.nix)



## secrets\.nextcloud\.enable



Whether to enable Nextcloud secrets\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/server/nextcloud/default\.nix](../modules/server/nextcloud/default.nix)



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



## ssh\.enable



Whether to enable ssh\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/core/ssh\.nix](../modules/core/ssh.nix)



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


