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



## cosmic-manager\.enable



Whether to enable enables cosmic-manager customisations\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/cosmic-manager](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/cosmic-manager)



## gaming\.enable



Whether to enable enables all gaming clients\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/gaming](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/gaming)



## gaming\.heroic\.enable



Whether to enable enables heroic games launcher\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/gaming/heroic\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/gaming/heroic.nix)



## gaming\.lutris\.enable



Whether to enable enables lutris games launcher\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/gaming/lutris\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/gaming/lutris.nix)



## gaming\.prism\.enable



Whether to enable enables prism minecraft launcher\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/gaming/prism\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/gaming/prism.nix)



## photography\.enable



Whether to enable enables all photography applications\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/photography](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/photography)



## photography\.darktable\.enable



Whether to enable enables darktable editing app\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/photography/darktable\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/photography/darktable.nix)



## photography\.gimp\.enable



Whether to enable enables gimp editing app\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/photography/gimp\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/photography/gimp.nix)



## photography\.krita\.enable



Whether to enable enables krita editing app\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/photography/krita\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/photography/krita.nix)



## photography\.vuescan\.enable



Whether to enable enables vuescan scanning app\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/photography/vuescan\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/photography/vuescan.nix)



## plasma-manager\.enable



Whether to enable enables plasma-manager customisations\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/plasma-manager](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/plasma-manager)



## secrets\.enable



Whether to enable enables importing secrets using sops-nix\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/secrets](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/secrets)



## utilities\.enable



Whether to enable enables all utility applications\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities)



## utilities\.calculator\.enable



Whether to enable enables kalc calculator\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/calculator\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/calculator.nix)



## utilities\.calibre\.enable



Whether to enable enables calibre ebook manager\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/calibre\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/calibre.nix)



## utilities\.camera\.enable



Whether to enable enables komoso camera\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/camera\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/camera.nix)



## utilities\.discover\.enable



Whether to enable enables discover app store\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/discover\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/discover.nix)



## utilities\.office\.enable



Whether to enable enables libreoffice suite\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/office\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/office.nix)



## utilities\.remoteDesktop\.enable



Whether to enable enables krdp remote desktop client\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/remote-desktop\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/remote-desktop.nix)



## utilities\.screenshot\.enable



Whether to enable enables spectacle screenshot tool\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/screenshot\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/screenshot.nix)



## utilities\.spotify\.enable



Whether to enable enables spotify music player\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/spotify\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/spotify.nix)



## utilities\.vlc\.enable



Whether to enable enables VLC media player\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/vlc\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/utilities/vlc.nix)



## web\.enable



Whether to enable enables all web utilities\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/web](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/web)



## web\.brave\.enable



Whether to enable enables brave web browser\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/web/brave\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/web/brave.nix)



## web\.chrome\.enable



Whether to enable enables chrome web browser\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/web/chrome\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/web/chrome.nix)



## web\.firefox\.enable



Whether to enable enables firefox web browser\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/web/firefox\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/web/firefox.nix)



## web\.ktorrent\.enable



Whether to enable enables ktorrent client\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/web/ktorrent\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/web/ktorrent.nix)



## web\.thunderbird\.enable



Whether to enable enables thunderbird email client\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `

*Declared by:*
 - [/nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/web/thunderbird\.nix](file:///nix/store/k4lgacxa77wdk8466h4x4mrlj7izz3zq-source/modules/home-manager/web/thunderbird.nix)


