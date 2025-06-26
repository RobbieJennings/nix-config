## _module\.args

Additional arguments passed to each module in addition to ones
like ` lib `, ` config `,
and ` pkgs `, ` modulesPath `\.

This option is also available to all submodules\. Submodules do not
inherit args from their parent module, nor do they provide args to
their parent module or sibling submodules\. The sole exception to
this is the argument ` name ` which is provided by
parent modules to a submodule and contains the attribute name
the submodule is bound to, or a unique generated name if it is
not bound to an attribute\.

Some arguments are already passed by default, of which the
following *cannot* be changed with this option:

 - ` lib `: The nixpkgs library\.

 - ` config `: The results of all options after merging the values from all modules together\.

 - ` options `: The options declared in all modules\.

 - ` specialArgs `: The ` specialArgs ` argument passed to ` evalModules `\.

 - All attributes of ` specialArgs `
   
   Whereas option values can generally depend on other option values
   thanks to laziness, this does not apply to ` imports `, which
   must be computed statically before anything else\.
   
   For this reason, callers of the module system can provide ` specialArgs `
   which are available during import resolution\.
   
   For NixOS, ` specialArgs ` includes
   ` modulesPath `, which allows you to import
   extra modules from the nixpkgs package tree without having to
   somehow make the module aware of the location of the
   ` nixpkgs ` or NixOS directories\.
   
   ```
   { modulesPath, ... }: {
     imports = [
       (modulesPath + "/profiles/minimal.nix")
     ];
   }
   ```

For NixOS, the default value for this option includes at least this argument:

 - ` pkgs `: The nixpkgs package set according to
   the ` nixpkgs.pkgs ` option\.



*Type:*
lazy attribute set of raw value

*Declared by:*
 - [\<nixpkgs/lib/modules\.nix>](https://github.com/NixOS/nixpkgs/blob//lib/modules.nix)



## auto-upgrade\.enable



Whether to enable enables automatic update of nix flake from github\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/auto-upgrade\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/auto-upgrade.nix)



## bootloader\.enable



Whether to enable enables grub bootloader\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/bootloader\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/bootloader.nix)



## bootloader\.pretty



Whether to enable enables silent boot with breeze theme\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/bootloader\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/bootloader.nix)



## desktop\.enable



Whether to enable enables default desktop modules\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop)



## desktop\.audio\.enable



Whether to enable enables audio using pipewire\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/audio\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/audio.nix)



## desktop\.bluetooth\.enable



Whether to enable enables bluetooth\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/bluetooth\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/bluetooth.nix)



## desktop\.cosmic-desktop\.enable



Whether to enable enables cosmic desktop environment\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/cosmic-desktop\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/cosmic-desktop.nix)



## desktop\.kde-connect\.enable



Whether to enable enables kde connect phone pairing app\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/kde-connect\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/kde-connect.nix)



## desktop\.kde-plasma\.enable



Whether to enable enables kde plasma desktop environment\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/kde-plasma\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/kde-plasma.nix)



## desktop\.printing\.enable



Whether to enable enables printing using CUPS\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/printing\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/printing.nix)



## desktop\.scanning\.enable



Whether to enable enables scanning using SANE and installs necessary drivers for Epson Perfection V550 Scanner\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/scanning\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/scanning.nix)



## desktop\.steam\.enable



Whether to enable enables steam gaming client\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/steam\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/steam.nix)



## desktop\.virtualisation\.enable



Whether to enable enables virtualisation using libvirt \& qemu\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/virtualisation\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/desktop/virtualisation.nix)



## garbage-collection\.enable



Whether to enable enables automatic garbage collection of nix store\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/garbage-collection\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/garbage-collection.nix)



## impermanence\.enable



Whether to enable enables impermanence\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/impermanence\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/impermanence.nix)



## localisation\.enable



Whether to enable enables localisation settings for Dublin\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/localisation\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/localisation.nix)



## networking\.enable



Whether to enable enables networking using networkmanager\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/networking\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/networking.nix)



## secrets\.enable



Whether to enable enables importing secrets using sops-nix\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/secrets\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/secrets.nix)



## server\.enable



Whether to enable enables default server modules\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/server](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/server)



## server\.hello-world\.enable



Whether to enable deploys hello world helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/server/hello-world\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/server/hello-world.nix)



## server\.jellyfin\.enable



Whether to enable deploys jellyfin helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/server/jellyfin\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/server/jellyfin.nix)



## server\.kubernetes\.enable



Whether to enable enables k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/server/kubernetes\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/server/kubernetes.nix)



## server\.longhorn\.enable



Whether to enable deploys longhorn helm chart on k3s\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/server/longhorn\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/server/longhorn.nix)



## zsh\.enable



Whether to enable enables zsh\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/zsh\.nix](file:///nix/store/2kxf2grwhdw06v077s04y2ssbhdd767a-source/modules/nixos/core/zsh.nix)


