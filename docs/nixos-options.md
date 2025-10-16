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



Whether to enable silent boot with breeze theme\.



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



## server\.jellyfin\.enable



Whether to enable jellyfin helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [modules/nixos/server/jellyfin\.nix](../modules/nixos/server/jellyfin.nix)



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


