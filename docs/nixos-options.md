## audio\.enable

Whether to enable audio using pipewire\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/desktop/audio\.nix](../modules/desktop/audio.nix)



## auto-upgrade\.enable



Whether to enable automatic update of nix flake from github\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/auto-upgrade\.nix](../modules/core/auto-upgrade.nix)



## blog\.enable



Whether to enable Blog deployment on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/blog/default\.nix](../modules/server/blog/default.nix)



## blog\.loadBalancerIP



MetalLB IP address for Blog



*Type:*
string



*Default:*

```nix
"192.168.1.209"
```

*Declared by:*
 - [modules/server/blog/services\.nix](../modules/server/blog/services.nix)



## blog\.loadBalancerPort



MetalLB port for Blog



*Type:*
signed integer



*Default:*

```nix
8080
```

*Declared by:*
 - [modules/server/blog/services\.nix](../modules/server/blog/services.nix)



## blog\.resources



Resource profile for Blog



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "10m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/blog/deployment\.nix](../modules/server/blog/deployment.nix)



## blog\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/blog/deployment\.nix](../modules/server/blog/deployment.nix)



## blog\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/blog/deployment\.nix](../modules/server/blog/deployment.nix)



## blog\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/blog/deployment\.nix](../modules/server/blog/deployment.nix)



## blog\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/blog/deployment\.nix](../modules/server/blog/deployment.nix)



## bluetooth\.enable



Whether to enable bluetooth\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/desktop/bluetooth\.nix](../modules/desktop/bluetooth.nix)



## bootloader\.enable



Whether to enable systemd-boot bootloader\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/bootloader\.nix](../modules/core/bootloader.nix)



## bootloader\.pretty



Whether to enable silent boot with plymouth\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/bootloader\.nix](../modules/core/bootloader.nix)



## cert-manager\.enable



Whether to enable Cert-manager helm chart on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/cert-manager/default\.nix](../modules/server/cert-manager/default.nix)



## cert-manager\.cainjectorResources



Resource profile for cert-manager’s ca-injector



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "200m";
    memory = "128Mi";
  };
  requests = {
    cpu = "10m";
    memory = "32Mi";
  };
}
```

*Declared by:*
 - [modules/server/cert-manager/settings\.nix](../modules/server/cert-manager/settings.nix)



## cert-manager\.cainjectorResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/cert-manager/settings\.nix](../modules/server/cert-manager/settings.nix)



## cert-manager\.cainjectorResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/cert-manager/settings\.nix](../modules/server/cert-manager/settings.nix)



## cert-manager\.cainjectorResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/cert-manager/settings\.nix](../modules/server/cert-manager/settings.nix)



## cert-manager\.cainjectorResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/cert-manager/settings\.nix](../modules/server/cert-manager/settings.nix)



## cert-manager\.certManagerResources



Resource profile for cert-manager



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "20m";
    memory = "48Mi";
  };
}
```

*Declared by:*
 - [modules/server/cert-manager/settings\.nix](../modules/server/cert-manager/settings.nix)



## cert-manager\.certManagerResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/cert-manager/settings\.nix](../modules/server/cert-manager/settings.nix)



## cert-manager\.certManagerResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/cert-manager/settings\.nix](../modules/server/cert-manager/settings.nix)



## cert-manager\.certManagerResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/cert-manager/settings\.nix](../modules/server/cert-manager/settings.nix)



## cert-manager\.certManagerResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/cert-manager/settings\.nix](../modules/server/cert-manager/settings.nix)



## cert-manager\.webhookResources



Resource profile for cert-manager’s webhook



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "20m";
    memory = "48Mi";
  };
}
```

*Declared by:*
 - [modules/server/cert-manager/settings\.nix](../modules/server/cert-manager/settings.nix)



## cert-manager\.webhookResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/cert-manager/settings\.nix](../modules/server/cert-manager/settings.nix)



## cert-manager\.webhookResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/cert-manager/settings\.nix](../modules/server/cert-manager/settings.nix)



## cert-manager\.webhookResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/cert-manager/settings\.nix](../modules/server/cert-manager/settings.nix)



## cert-manager\.webhookResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/cert-manager/settings\.nix](../modules/server/cert-manager/settings.nix)



## cosmic-desktop\.enable



Whether to enable cosmic desktop environment\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/desktop/cosmic-desktop\.nix](../modules/desktop/cosmic-desktop.nix)



## desktopEnvironment



Select desktop environment: Plasma or COSMIC\.



*Type:*
one of “plasma”, “cosmic”



*Default:*

```nix
"plasma"
```

*Declared by:*
 - [modules/desktop/default\.nix](../modules/desktop/default.nix)



## docker\.enable



Whether to enable docker\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/docker\.nix](../modules/core/docker.nix)



## environment\.persistence



A set of persistent storage location submodules listing the
files and directories to link to their respective persistent
storage location\.

Each attribute name should be the full path to a persistent
storage location\.

For detailed usage, check the \<link
xlink:href=“https://github\.com/nix-community/impermanence”>documentation\</link>\.



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```



*Example:*

```nix
{
  "/persistent" = {
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];
    files = [
      "/etc/machine-id"
      { file = "/etc/nix/id_rsa"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
  };
  users.talyz = { ... }; # See the dedicated example
}

```

*Declared by:*
 - [modules/core/impermanence\.nix](../modules/core/impermanence.nix)



## environment\.persistence\.\<name>\.users



A set of user submodules listing the files and
directories to link to their respective user’s
home directories\.

Each attribute name should be the name of the
user\.

For detailed usage, check the \<link
xlink:href=“https://github\.com/nix-community/impermanence”>documentation\</link>\.



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```



*Example:*

```nix
{
  talyz = {
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      "VirtualBox VMs"
      { directory = ".gnupg"; mode = "0700"; }
      { directory = ".ssh"; mode = "0700"; }
      { directory = ".nixops"; mode = "0700"; }
      { directory = ".local/share/keyrings"; mode = "0700"; }
      ".local/share/direnv"
    ];
    files = [
      ".screenrc"
    ];
  };
}

```

*Declared by:*
 - [modules/core/impermanence\.nix](../modules/core/impermanence.nix)



## forgejo\.enable



Whether to enable forgejo helm chart on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/forgejo/default\.nix](../modules/server/forgejo/default.nix)



## forgejo\.barmanResources



Resource profile for Forgejo’s Barman backup sidecar



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "25m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/forgejo/postgres\.nix](../modules/server/forgejo/postgres.nix)



## forgejo\.barmanResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/postgres\.nix](../modules/server/forgejo/postgres.nix)



## forgejo\.barmanResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/postgres\.nix](../modules/server/forgejo/postgres.nix)



## forgejo\.barmanResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/postgres\.nix](../modules/server/forgejo/postgres.nix)



## forgejo\.barmanResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/postgres\.nix](../modules/server/forgejo/postgres.nix)



## forgejo\.forgejoVolumeSize



Volume size for Forgejo



*Type:*
string



*Default:*

```nix
"100Gi"
```

*Declared by:*
 - [modules/server/forgejo/persistence\.nix](../modules/server/forgejo/persistence.nix)



## forgejo\.initdb\.enable



Whether to enable initialize fresh postgres database for Forgejo\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/forgejo/postgres\.nix](../modules/server/forgejo/postgres.nix)



## forgejo\.loadBalancerIP



MetalLB IP address for Forgejo



*Type:*
string



*Default:*

```nix
"192.168.1.204"
```

*Declared by:*
 - [modules/server/forgejo/services\.nix](../modules/server/forgejo/services.nix)



## forgejo\.loadBalancerPort



MetalLB port for Forgejo



*Type:*
signed integer



*Default:*

```nix
3000
```

*Declared by:*
 - [modules/server/forgejo/services\.nix](../modules/server/forgejo/services.nix)



## forgejo\.loadBalancerSshPort



MetalLB ssh port for Forgejo



*Type:*
signed integer



*Default:*

```nix
22
```

*Declared by:*
 - [modules/server/forgejo/services\.nix](../modules/server/forgejo/services.nix)



## forgejo\.postgresResources



Resource profile for Forgejo’s CNPG database



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "1000m";
    memory = "512Mi";
  };
  requests = {
    cpu = "20m";
    memory = "128Mi";
  };
}
```

*Declared by:*
 - [modules/server/forgejo/postgres\.nix](../modules/server/forgejo/postgres.nix)



## forgejo\.postgresResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/postgres\.nix](../modules/server/forgejo/postgres.nix)



## forgejo\.postgresResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/postgres\.nix](../modules/server/forgejo/postgres.nix)



## forgejo\.postgresResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/postgres\.nix](../modules/server/forgejo/postgres.nix)



## forgejo\.postgresResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/postgres\.nix](../modules/server/forgejo/postgres.nix)



## forgejo\.postgresVolumeSize



Volume size for Forgejo’s Postgres Database



*Type:*
string



*Default:*

```nix
"8Gi"
```

*Declared by:*
 - [modules/server/forgejo/persistence\.nix](../modules/server/forgejo/persistence.nix)



## forgejo\.redisExporterResources



Resource profile for Forgejo’s cache metrics exporter



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "200m";
    memory = "128Mi";
  };
  requests = {
    cpu = "10m";
    memory = "32Mi";
  };
}
```

*Declared by:*
 - [modules/server/forgejo/valkey\.nix](../modules/server/forgejo/valkey.nix)



## forgejo\.redisExporterResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/valkey\.nix](../modules/server/forgejo/valkey.nix)



## forgejo\.redisExporterResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/valkey\.nix](../modules/server/forgejo/valkey.nix)



## forgejo\.redisExporterResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/valkey\.nix](../modules/server/forgejo/valkey.nix)



## forgejo\.redisExporterResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/valkey\.nix](../modules/server/forgejo/valkey.nix)



## forgejo\.resources



Resource profile for Forgejo



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "1000m";
    memory = "512Mi";
  };
  requests = {
    cpu = "20m";
    memory = "128Mi";
  };
}
```

*Declared by:*
 - [modules/server/forgejo/settings\.nix](../modules/server/forgejo/settings.nix)



## forgejo\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/settings\.nix](../modules/server/forgejo/settings.nix)



## forgejo\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/settings\.nix](../modules/server/forgejo/settings.nix)



## forgejo\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/settings\.nix](../modules/server/forgejo/settings.nix)



## forgejo\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/settings\.nix](../modules/server/forgejo/settings.nix)



## forgejo\.valkeyResources



Resource profile for Forgejo’s cache



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "200m";
    memory = "256Mi";
  };
  requests = {
    cpu = "10m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/forgejo/valkey\.nix](../modules/server/forgejo/valkey.nix)



## forgejo\.valkeyResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/valkey\.nix](../modules/server/forgejo/valkey.nix)



## forgejo\.valkeyResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/valkey\.nix](../modules/server/forgejo/valkey.nix)



## forgejo\.valkeyResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/valkey\.nix](../modules/server/forgejo/valkey.nix)



## forgejo\.valkeyResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/forgejo/valkey\.nix](../modules/server/forgejo/valkey.nix)



## freshrss\.enable



Whether to enable FreshRSS deployment on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/freshrss/default\.nix](../modules/server/freshrss/default.nix)



## freshrss\.freshrssVolumeSize



Volume size for Freshrss



*Type:*
string



*Default:*

```nix
"10Gi"
```

*Declared by:*
 - [modules/server/freshrss/persistence\.nix](../modules/server/freshrss/persistence.nix)



## freshrss\.loadBalancerIP



MetalLB IP address for FreshRSS



*Type:*
string



*Default:*

```nix
"192.168.1.207"
```

*Declared by:*
 - [modules/server/freshrss/services\.nix](../modules/server/freshrss/services.nix)



## freshrss\.loadBalancerPort



MetalLB port for FreshRSS



*Type:*
signed integer



*Default:*

```nix
80
```

*Declared by:*
 - [modules/server/freshrss/services\.nix](../modules/server/freshrss/services.nix)



## freshrss\.refreshJobResources



Resource profile for FreshRSS refresh cron job



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "1000m";
    memory = "512Mi";
  };
  requests = {
    cpu = "20m";
    memory = "128Mi";
  };
}
```

*Declared by:*
 - [modules/server/freshrss/cronjob\.nix](../modules/server/freshrss/cronjob.nix)



## freshrss\.refreshJobResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/freshrss/cronjob\.nix](../modules/server/freshrss/cronjob.nix)



## freshrss\.refreshJobResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/freshrss/cronjob\.nix](../modules/server/freshrss/cronjob.nix)



## freshrss\.refreshJobResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/freshrss/cronjob\.nix](../modules/server/freshrss/cronjob.nix)



## freshrss\.refreshJobResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/freshrss/cronjob\.nix](../modules/server/freshrss/cronjob.nix)



## freshrss\.resources



Resource profile for FreshRSS



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "1000m";
    memory = "512Mi";
  };
  requests = {
    cpu = "20m";
    memory = "128Mi";
  };
}
```

*Declared by:*
 - [modules/server/freshrss/deployment\.nix](../modules/server/freshrss/deployment.nix)



## freshrss\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/freshrss/deployment\.nix](../modules/server/freshrss/deployment.nix)



## freshrss\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/freshrss/deployment\.nix](../modules/server/freshrss/deployment.nix)



## freshrss\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/freshrss/deployment\.nix](../modules/server/freshrss/deployment.nix)



## freshrss\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/freshrss/deployment\.nix](../modules/server/freshrss/deployment.nix)



## fwupd\.enable



Whether to enable firmware update manager\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/fwupd\.nix](../modules/core/fwupd.nix)



## garage\.enable



Whether to enable garage helm chart on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/garage/default\.nix](../modules/server/garage/default.nix)



## garage\.dataVolumeSize



Volume size for Garage data



*Type:*
string



*Default:*

```nix
"100Gi"
```

*Declared by:*
 - [modules/server/garage/persistence\.nix](../modules/server/garage/persistence.nix)



## garage\.loadBalancerAdminPort



MetalLB port for Garage Admin



*Type:*
signed integer



*Default:*

```nix
3903
```

*Declared by:*
 - [modules/server/garage/services\.nix](../modules/server/garage/services.nix)



## garage\.loadBalancerApiPort



MetalLB port for Garage API



*Type:*
signed integer



*Default:*

```nix
3900
```

*Declared by:*
 - [modules/server/garage/services\.nix](../modules/server/garage/services.nix)



## garage\.loadBalancerIP



MetalLB IP address for Garage



*Type:*
string



*Default:*

```nix
"192.168.1.208"
```

*Declared by:*
 - [modules/server/garage/services\.nix](../modules/server/garage/services.nix)



## garage\.loadBalancerUIPort



MetalLB port for Garage Web UI



*Type:*
signed integer



*Default:*

```nix
3909
```

*Declared by:*
 - [modules/server/garage/services\.nix](../modules/server/garage/services.nix)



## garage\.loadBalancerWebPort



MetalLB port for Garage Web



*Type:*
signed integer



*Default:*

```nix
3902
```

*Declared by:*
 - [modules/server/garage/services\.nix](../modules/server/garage/services.nix)



## garage\.metaVolumeSize



Volume size for Garage metadata



*Type:*
string



*Default:*

```nix
"10Gi"
```

*Declared by:*
 - [modules/server/garage/persistence\.nix](../modules/server/garage/persistence.nix)



## garage\.resources



Resource profile for Garage



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "1000m";
    memory = "512Mi";
  };
  requests = {
    cpu = "20m";
    memory = "128Mi";
  };
}
```

*Declared by:*
 - [modules/server/garage/settings\.nix](../modules/server/garage/settings.nix)



## garage\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/garage/settings\.nix](../modules/server/garage/settings.nix)



## garage\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/garage/settings\.nix](../modules/server/garage/settings.nix)



## garage\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/garage/settings\.nix](../modules/server/garage/settings.nix)



## garage\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/garage/settings\.nix](../modules/server/garage/settings.nix)



## garage\.webUiResources



Resource profile for Garage Web UI



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "1000m";
    memory = "512Mi";
  };
  requests = {
    cpu = "20m";
    memory = "128Mi";
  };
}
```

*Declared by:*
 - [modules/server/garage/web-ui\.nix](../modules/server/garage/web-ui.nix)



## garage\.webUiResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/garage/web-ui\.nix](../modules/server/garage/web-ui.nix)



## garage\.webUiResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/garage/web-ui\.nix](../modules/server/garage/web-ui.nix)



## garage\.webUiResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/garage/web-ui\.nix](../modules/server/garage/web-ui.nix)



## garage\.webUiResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/garage/web-ui\.nix](../modules/server/garage/web-ui.nix)



## garbage-collection\.enable



Whether to enable automatic garbage collection of nix store\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/garbage-collection\.nix](../modules/core/garbage-collection.nix)



## homepage\.enable

Whether to enable Homepage deployment on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/homepage/default\.nix](../modules/server/homepage/default.nix)



## homepage\.loadBalancerIP



MetalLB IP address for Homepage



*Type:*
string



*Default:*

```nix
"192.168.1.200"
```

*Declared by:*
 - [modules/server/homepage/services\.nix](../modules/server/homepage/services.nix)



## homepage\.loadBalancerPort



MetalLB port for Homepage



*Type:*
signed integer



*Default:*

```nix
80
```

*Declared by:*
 - [modules/server/homepage/services\.nix](../modules/server/homepage/services.nix)



## homepage\.resources



Resource profile for Homepage



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "10m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/homepage/deployment\.nix](../modules/server/homepage/deployment.nix)



## homepage\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/homepage/deployment\.nix](../modules/server/homepage/deployment.nix)



## homepage\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/homepage/deployment\.nix](../modules/server/homepage/deployment.nix)



## homepage\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/homepage/deployment\.nix](../modules/server/homepage/deployment.nix)



## homepage\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/homepage/deployment\.nix](../modules/server/homepage/deployment.nix)



## immich\.enable



Whether to enable Immich helm chart on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/immich/default\.nix](../modules/server/immich/default.nix)



## immich\.barmanResources



Resource profile for Immich’s Barman backup sidecar



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "25m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/immich/postgres\.nix](../modules/server/immich/postgres.nix)



## immich\.barmanResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/immich/postgres\.nix](../modules/server/immich/postgres.nix)



## immich\.barmanResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/immich/postgres\.nix](../modules/server/immich/postgres.nix)



## immich\.barmanResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/immich/postgres\.nix](../modules/server/immich/postgres.nix)



## immich\.barmanResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/immich/postgres\.nix](../modules/server/immich/postgres.nix)



## immich\.immichVolumeSize



Volume size for Immich



*Type:*
string



*Default:*

```nix
"100Gi"
```

*Declared by:*
 - [modules/server/immich/persistence\.nix](../modules/server/immich/persistence.nix)



## immich\.initdb\.enable



Whether to enable initialize fresh postgres database for Immich\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/immich/postgres\.nix](../modules/server/immich/postgres.nix)



## immich\.loadBalancerIP



MetalLB IP address for Immich



*Type:*
string



*Default:*

```nix
"192.168.1.205"
```

*Declared by:*
 - [modules/server/immich/services\.nix](../modules/server/immich/services.nix)



## immich\.loadBalancerPort



MetalLB port for Immich



*Type:*
signed integer



*Default:*

```nix
2283
```

*Declared by:*
 - [modules/server/immich/services\.nix](../modules/server/immich/services.nix)



## immich\.postgresResources



Resource profile for Immich’s CNPG database



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "2000m";
    memory = "2Gi";
  };
  requests = {
    cpu = "50m";
    memory = "256Mi";
  };
}
```

*Declared by:*
 - [modules/server/immich/postgres\.nix](../modules/server/immich/postgres.nix)



## immich\.postgresResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/immich/postgres\.nix](../modules/server/immich/postgres.nix)



## immich\.postgresResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/immich/postgres\.nix](../modules/server/immich/postgres.nix)



## immich\.postgresResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/immich/postgres\.nix](../modules/server/immich/postgres.nix)



## immich\.postgresResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/immich/postgres\.nix](../modules/server/immich/postgres.nix)



## immich\.postgresVolumeSize



Volume size for Immich’s Postgres Database



*Type:*
string



*Default:*

```nix
"8Gi"
```

*Declared by:*
 - [modules/server/immich/persistence\.nix](../modules/server/immich/persistence.nix)



## immich\.resources



Resource profile for Immich



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "2000m";
    memory = "2Gi";
  };
  requests = {
    cpu = "100m";
    memory = "512Mi";
  };
}
```

*Declared by:*
 - [modules/server/immich/settings\.nix](../modules/server/immich/settings.nix)



## immich\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/immich/settings\.nix](../modules/server/immich/settings.nix)



## immich\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/immich/settings\.nix](../modules/server/immich/settings.nix)



## immich\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/immich/settings\.nix](../modules/server/immich/settings.nix)



## immich\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/immich/settings\.nix](../modules/server/immich/settings.nix)



## immich\.valkeyResources



Resource profile for Immich’s cache



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "200m";
    memory = "256Mi";
  };
  requests = {
    cpu = "10m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/immich/valkey\.nix](../modules/server/immich/valkey.nix)



## immich\.valkeyResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/immich/valkey\.nix](../modules/server/immich/valkey.nix)



## immich\.valkeyResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/immich/valkey\.nix](../modules/server/immich/valkey.nix)



## immich\.valkeyResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/immich/valkey\.nix](../modules/server/immich/valkey.nix)



## immich\.valkeyResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/immich/valkey\.nix](../modules/server/immich/valkey.nix)



## impermanence\.enable



Whether to enable impermanence\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/impermanence\.nix](../modules/core/impermanence.nix)



## intel-device-plugins\.enable



Whether to enable Intel device plugins for kubernetes\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/intel-plugins/default\.nix](../modules/server/intel-plugins/default.nix)



## intel-device-plugins\.gpu\.enable



Whether to enable Intel GPU plugin for Kubernetes\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/intel-plugins/gpu-device-plugin\.nix](../modules/server/intel-plugins/gpu-device-plugin.nix)



## intel-device-plugins\.operator\.enable



Whether to enable Intel Device Plugins Operator\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/intel-plugins/device-plugins-operator\.nix](../modules/server/intel-plugins/device-plugins-operator.nix)



## intel-device-plugins\.operatorResources



Resource profile for Intel device plugin operator



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "200m";
    memory = "128Mi";
  };
  requests = {
    cpu = "10m";
    memory = "32Mi";
  };
}
```

*Declared by:*
 - [modules/server/intel-plugins/device-plugins-operator\.nix](../modules/server/intel-plugins/device-plugins-operator.nix)



## intel-device-plugins\.operatorResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/intel-plugins/device-plugins-operator\.nix](../modules/server/intel-plugins/device-plugins-operator.nix)



## intel-device-plugins\.operatorResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/intel-plugins/device-plugins-operator\.nix](../modules/server/intel-plugins/device-plugins-operator.nix)



## intel-device-plugins\.operatorResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/intel-plugins/device-plugins-operator\.nix](../modules/server/intel-plugins/device-plugins-operator.nix)



## intel-device-plugins\.operatorResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/intel-plugins/device-plugins-operator\.nix](../modules/server/intel-plugins/device-plugins-operator.nix)



## k3s\.enable



Whether to enable k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/k3s\.nix](../modules/server/k3s.nix)



## kde-connect\.enable



Whether to enable kde connect phone pairing app\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/desktop/kde-connect\.nix](../modules/desktop/kde-connect.nix)



## kde-plasma\.enable



Whether to enable kde plasma desktop environment\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/desktop/kde-plasma\.nix](../modules/desktop/kde-plasma.nix)



## localisation\.enable



Whether to enable localisation settings for Dublin\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/localisation\.nix](../modules/core/localisation.nix)



## longhorn\.enable



Whether to enable longhorn helm chart on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/longhorn/default\.nix](../modules/server/longhorn/default.nix)



## longhorn\.loadBalancerIP



MetalLB IP address for Longhorn



*Type:*
string



*Default:*

```nix
"192.168.1.201"
```

*Declared by:*
 - [modules/server/longhorn/services\.nix](../modules/server/longhorn/services.nix)



## longhorn\.loadBalancerPort



MetalLB port for Longhorn



*Type:*
signed integer



*Default:*

```nix
80
```

*Declared by:*
 - [modules/server/longhorn/services\.nix](../modules/server/longhorn/services.nix)



## media-server\.enable



Whether to enable jellyfin, transmission and servarr services on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/media/default\.nix](../modules/server/media/default.nix)



## media-server\.audiobookshelf\.enable



Whether to enable Audiobookshelf deployment on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/media/audiobookshelf/default\.nix](../modules/server/media/audiobookshelf/default.nix)



## media-server\.audiobookshelf\.audioBookshelfVolumeSize



Volume size for Audiobookshelf



*Type:*
string



*Default:*

```nix
"5Gi"
```

*Declared by:*
 - [modules/server/media/audiobookshelf/persistence\.nix](../modules/server/media/audiobookshelf/persistence.nix)



## media-server\.audiobookshelf\.loadBalancerIP



MetalLB IP address for Audiobookshelf



*Type:*
string



*Default:*

```nix
"192.168.1.202"
```

*Declared by:*
 - [modules/server/media/audiobookshelf/services\.nix](../modules/server/media/audiobookshelf/services.nix)



## media-server\.audiobookshelf\.loadBalancerPort



MetalLB port for Audiobookshelf



*Type:*
signed integer



*Default:*

```nix
13378
```

*Declared by:*
 - [modules/server/media/audiobookshelf/services\.nix](../modules/server/media/audiobookshelf/services.nix)



## media-server\.audiobookshelf\.resources



Resource profile for Audiobookshelf



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "1000m";
    memory = "512Mi";
  };
  requests = {
    cpu = "20m";
    memory = "128Mi";
  };
}
```

*Declared by:*
 - [modules/server/media/audiobookshelf/deployment\.nix](../modules/server/media/audiobookshelf/deployment.nix)



## media-server\.audiobookshelf\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/media/audiobookshelf/deployment\.nix](../modules/server/media/audiobookshelf/deployment.nix)



## media-server\.audiobookshelf\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/media/audiobookshelf/deployment\.nix](../modules/server/media/audiobookshelf/deployment.nix)



## media-server\.audiobookshelf\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/media/audiobookshelf/deployment\.nix](../modules/server/media/audiobookshelf/deployment.nix)



## media-server\.audiobookshelf\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/media/audiobookshelf/deployment\.nix](../modules/server/media/audiobookshelf/deployment.nix)



## media-server\.calibre-web-automated\.enable



Whether to enable Calibre-Web-Automated deployment on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/media/calibre-web-automated/default\.nix](../modules/server/media/calibre-web-automated/default.nix)



## media-server\.calibre-web-automated\.calibreWebAutomatedVolumeSize



Volume size for Calibre-Web-Automated



*Type:*
string



*Default:*

```nix
"5Gi"
```

*Declared by:*
 - [modules/server/media/calibre-web-automated/persistence\.nix](../modules/server/media/calibre-web-automated/persistence.nix)



## media-server\.calibre-web-automated\.loadBalancerIP



MetalLB IP address for Calibre-Web-Automated



*Type:*
string



*Default:*

```nix
"192.168.1.202"
```

*Declared by:*
 - [modules/server/media/calibre-web-automated/services\.nix](../modules/server/media/calibre-web-automated/services.nix)



## media-server\.calibre-web-automated\.loadBalancerPort



MetalLB port for Calibre-Web-Automated



*Type:*
signed integer



*Default:*

```nix
8083
```

*Declared by:*
 - [modules/server/media/calibre-web-automated/services\.nix](../modules/server/media/calibre-web-automated/services.nix)



## media-server\.calibre-web-automated\.resources



Resource profile for Calibre-Web-Automated



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "1000m";
    memory = "512Mi";
  };
  requests = {
    cpu = "20m";
    memory = "128Mi";
  };
}
```

*Declared by:*
 - [modules/server/media/calibre-web-automated/deployment\.nix](../modules/server/media/calibre-web-automated/deployment.nix)



## media-server\.calibre-web-automated\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/media/calibre-web-automated/deployment\.nix](../modules/server/media/calibre-web-automated/deployment.nix)



## media-server\.calibre-web-automated\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/media/calibre-web-automated/deployment\.nix](../modules/server/media/calibre-web-automated/deployment.nix)



## media-server\.calibre-web-automated\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/media/calibre-web-automated/deployment\.nix](../modules/server/media/calibre-web-automated/deployment.nix)



## media-server\.calibre-web-automated\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/media/calibre-web-automated/deployment\.nix](../modules/server/media/calibre-web-automated/deployment.nix)



## media-server\.downloadVolumeSize



Volume size for download files



*Type:*
string



*Default:*

```nix
"100Gi"
```

*Declared by:*
 - [modules/server/media/persistence\.nix](../modules/server/media/persistence.nix)



## media-server\.flaresolverr\.enable



Whether to enable Flaresolverr deployment on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/media/flaresolverr/default\.nix](../modules/server/media/flaresolverr/default.nix)



## media-server\.flaresolverr\.loadBalancerIP



MetalLB IP address for Flaresolverr



*Type:*
string



*Default:*

```nix
"192.168.1.202"
```

*Declared by:*
 - [modules/server/media/flaresolverr/services\.nix](../modules/server/media/flaresolverr/services.nix)



## media-server\.flaresolverr\.loadBalancerPort



MetalLB port for Flaresolverr



*Type:*
signed integer



*Default:*

```nix
8191
```

*Declared by:*
 - [modules/server/media/flaresolverr/services\.nix](../modules/server/media/flaresolverr/services.nix)



## media-server\.flaresolverr\.resources



Resource profile for Flaresolverr



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "2000m";
    memory = "2Gi";
  };
  requests = {
    cpu = "100m";
    memory = "512Mi";
  };
}
```

*Declared by:*
 - [modules/server/media/flaresolverr/deployment\.nix](../modules/server/media/flaresolverr/deployment.nix)



## media-server\.flaresolverr\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/media/flaresolverr/deployment\.nix](../modules/server/media/flaresolverr/deployment.nix)



## media-server\.flaresolverr\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/media/flaresolverr/deployment\.nix](../modules/server/media/flaresolverr/deployment.nix)



## media-server\.flaresolverr\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/media/flaresolverr/deployment\.nix](../modules/server/media/flaresolverr/deployment.nix)



## media-server\.flaresolverr\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/media/flaresolverr/deployment\.nix](../modules/server/media/flaresolverr/deployment.nix)



## media-server\.jellyfin\.enable



Whether to enable Jellyfin deployment on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/media/jellyfin/default\.nix](../modules/server/media/jellyfin/default.nix)



## media-server\.jellyfin\.jellyfinVolumeSize



Volume size for Jellyfin



*Type:*
string



*Default:*

```nix
"5Gi"
```

*Declared by:*
 - [modules/server/media/jellyfin/persistence\.nix](../modules/server/media/jellyfin/persistence.nix)



## media-server\.jellyfin\.loadBalancerIP



MetalLB IP address for Jellyfin



*Type:*
string



*Default:*

```nix
"192.168.1.202"
```

*Declared by:*
 - [modules/server/media/jellyfin/services\.nix](../modules/server/media/jellyfin/services.nix)



## media-server\.jellyfin\.loadBalancerPort



MetalLB port for Jellyfin



*Type:*
signed integer



*Default:*

```nix
8096
```

*Declared by:*
 - [modules/server/media/jellyfin/services\.nix](../modules/server/media/jellyfin/services.nix)



## media-server\.jellyfin\.resources



Resource profile for Jellyfin



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "2000m";
    memory = "1Gi";
  };
  requests = {
    cpu = "50m";
    memory = "256Mi";
  };
}
```

*Declared by:*
 - [modules/server/media/jellyfin/deployment\.nix](../modules/server/media/jellyfin/deployment.nix)



## media-server\.jellyfin\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/media/jellyfin/deployment\.nix](../modules/server/media/jellyfin/deployment.nix)



## media-server\.jellyfin\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/media/jellyfin/deployment\.nix](../modules/server/media/jellyfin/deployment.nix)



## media-server\.jellyfin\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/media/jellyfin/deployment\.nix](../modules/server/media/jellyfin/deployment.nix)



## media-server\.jellyfin\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/media/jellyfin/deployment\.nix](../modules/server/media/jellyfin/deployment.nix)



## media-server\.lidarr\.enable



Whether to enable Lidarr deployment on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/media/lidarr/default\.nix](../modules/server/media/lidarr/default.nix)



## media-server\.lidarr\.lidarrVolumeSize



Volume size for Lidarr



*Type:*
string



*Default:*

```nix
"5Gi"
```

*Declared by:*
 - [modules/server/media/lidarr/persistence\.nix](../modules/server/media/lidarr/persistence.nix)



## media-server\.lidarr\.loadBalancerIP



MetalLB IP address for Lidarr



*Type:*
string



*Default:*

```nix
"192.168.1.202"
```

*Declared by:*
 - [modules/server/media/lidarr/services\.nix](../modules/server/media/lidarr/services.nix)



## media-server\.lidarr\.loadBalancerPort



MetalLB port for Lidarr



*Type:*
signed integer



*Default:*

```nix
8686
```

*Declared by:*
 - [modules/server/media/lidarr/services\.nix](../modules/server/media/lidarr/services.nix)



## media-server\.lidarr\.resources



Resource profile for Lidarr



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "1000m";
    memory = "512Mi";
  };
  requests = {
    cpu = "20m";
    memory = "128Mi";
  };
}
```

*Declared by:*
 - [modules/server/media/lidarr/deployment\.nix](../modules/server/media/lidarr/deployment.nix)



## media-server\.lidarr\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/media/lidarr/deployment\.nix](../modules/server/media/lidarr/deployment.nix)



## media-server\.lidarr\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/media/lidarr/deployment\.nix](../modules/server/media/lidarr/deployment.nix)



## media-server\.lidarr\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/media/lidarr/deployment\.nix](../modules/server/media/lidarr/deployment.nix)



## media-server\.lidarr\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/media/lidarr/deployment\.nix](../modules/server/media/lidarr/deployment.nix)



## media-server\.mediaVolumeSize



Volume size for media files



*Type:*
string



*Default:*

```nix
"100Gi"
```

*Declared by:*
 - [modules/server/media/persistence\.nix](../modules/server/media/persistence.nix)



## media-server\.prowlarr\.enable



Whether to enable Prowlarr deployment on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/media/prowlarr/default\.nix](../modules/server/media/prowlarr/default.nix)



## media-server\.prowlarr\.loadBalancerIP



MetalLB IP address for Prowlarr



*Type:*
string



*Default:*

```nix
"192.168.1.202"
```

*Declared by:*
 - [modules/server/media/prowlarr/services\.nix](../modules/server/media/prowlarr/services.nix)



## media-server\.prowlarr\.loadBalancerPort



MetalLB port for Prowlarr



*Type:*
signed integer



*Default:*

```nix
9696
```

*Declared by:*
 - [modules/server/media/prowlarr/services\.nix](../modules/server/media/prowlarr/services.nix)



## media-server\.prowlarr\.prowlarrVolumeSize

Volume size for Prowlarr



*Type:*
string



*Default:*

```nix
"5Gi"
```

*Declared by:*
 - [modules/server/media/prowlarr/persistence\.nix](../modules/server/media/prowlarr/persistence.nix)



## media-server\.prowlarr\.resources



Resource profile for Prowlarr



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "1000m";
    memory = "512Mi";
  };
  requests = {
    cpu = "20m";
    memory = "128Mi";
  };
}
```

*Declared by:*
 - [modules/server/media/prowlarr/deployment\.nix](../modules/server/media/prowlarr/deployment.nix)



## media-server\.prowlarr\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/media/prowlarr/deployment\.nix](../modules/server/media/prowlarr/deployment.nix)



## media-server\.prowlarr\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/media/prowlarr/deployment\.nix](../modules/server/media/prowlarr/deployment.nix)



## media-server\.prowlarr\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/media/prowlarr/deployment\.nix](../modules/server/media/prowlarr/deployment.nix)



## media-server\.prowlarr\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/media/prowlarr/deployment\.nix](../modules/server/media/prowlarr/deployment.nix)



## media-server\.radarr\.enable



Whether to enable Radarr deployment on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/media/radarr/default\.nix](../modules/server/media/radarr/default.nix)



## media-server\.radarr\.loadBalancerIP



MetalLB IP address for Radarr



*Type:*
string



*Default:*

```nix
"192.168.1.202"
```

*Declared by:*
 - [modules/server/media/radarr/services\.nix](../modules/server/media/radarr/services.nix)



## media-server\.radarr\.loadBalancerPort



MetalLB port for Radarr



*Type:*
signed integer



*Default:*

```nix
7878
```

*Declared by:*
 - [modules/server/media/radarr/services\.nix](../modules/server/media/radarr/services.nix)



## media-server\.radarr\.radarrVolumeSize



Volume size for Radarr



*Type:*
string



*Default:*

```nix
"5Gi"
```

*Declared by:*
 - [modules/server/media/radarr/persistence\.nix](../modules/server/media/radarr/persistence.nix)



## media-server\.radarr\.resources



Resource profile for Radarr



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "1000m";
    memory = "512Mi";
  };
  requests = {
    cpu = "20m";
    memory = "128Mi";
  };
}
```

*Declared by:*
 - [modules/server/media/radarr/deployment\.nix](../modules/server/media/radarr/deployment.nix)



## media-server\.radarr\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/media/radarr/deployment\.nix](../modules/server/media/radarr/deployment.nix)



## media-server\.radarr\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/media/radarr/deployment\.nix](../modules/server/media/radarr/deployment.nix)



## media-server\.radarr\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/media/radarr/deployment\.nix](../modules/server/media/radarr/deployment.nix)



## media-server\.radarr\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/media/radarr/deployment\.nix](../modules/server/media/radarr/deployment.nix)



## media-server\.seerr\.enable



Whether to enable Seerr deployment on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/media/seerr/default\.nix](../modules/server/media/seerr/default.nix)



## media-server\.seerr\.loadBalancerIP



MetalLB IP address for Seerr



*Type:*
string



*Default:*

```nix
"192.168.1.202"
```

*Declared by:*
 - [modules/server/media/seerr/services\.nix](../modules/server/media/seerr/services.nix)



## media-server\.seerr\.loadBalancerPort



MetalLB port for Seerr



*Type:*
signed integer



*Default:*

```nix
5055
```

*Declared by:*
 - [modules/server/media/seerr/services\.nix](../modules/server/media/seerr/services.nix)



## media-server\.seerr\.resources



Resource profile for Seerr



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "1000m";
    memory = "512Mi";
  };
  requests = {
    cpu = "20m";
    memory = "128Mi";
  };
}
```

*Declared by:*
 - [modules/server/media/seerr/deployment\.nix](../modules/server/media/seerr/deployment.nix)



## media-server\.seerr\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/media/seerr/deployment\.nix](../modules/server/media/seerr/deployment.nix)



## media-server\.seerr\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/media/seerr/deployment\.nix](../modules/server/media/seerr/deployment.nix)



## media-server\.seerr\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/media/seerr/deployment\.nix](../modules/server/media/seerr/deployment.nix)



## media-server\.seerr\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/media/seerr/deployment\.nix](../modules/server/media/seerr/deployment.nix)



## media-server\.seerr\.seerrVolumeSize



Volume size for Seerr



*Type:*
string



*Default:*

```nix
"5Gi"
```

*Declared by:*
 - [modules/server/media/seerr/persistence\.nix](../modules/server/media/seerr/persistence.nix)



## media-server\.shelfmark\.enable



Whether to enable Shelfmark deployment on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/media/shelfmark/default\.nix](../modules/server/media/shelfmark/default.nix)



## media-server\.shelfmark\.loadBalancerIP



MetalLB IP address for Shelfmark



*Type:*
string



*Default:*

```nix
"192.168.1.202"
```

*Declared by:*
 - [modules/server/media/shelfmark/services\.nix](../modules/server/media/shelfmark/services.nix)



## media-server\.shelfmark\.loadBalancerPort



MetalLB port for Shelfmark



*Type:*
signed integer



*Default:*

```nix
8084
```

*Declared by:*
 - [modules/server/media/shelfmark/services\.nix](../modules/server/media/shelfmark/services.nix)



## media-server\.shelfmark\.resources



Resource profile for Shelfmark



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "2000m";
    memory = "2Gi";
  };
  requests = {
    cpu = "100m";
    memory = "512Mi";
  };
}
```

*Declared by:*
 - [modules/server/media/shelfmark/deployment\.nix](../modules/server/media/shelfmark/deployment.nix)



## media-server\.shelfmark\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/media/shelfmark/deployment\.nix](../modules/server/media/shelfmark/deployment.nix)



## media-server\.shelfmark\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/media/shelfmark/deployment\.nix](../modules/server/media/shelfmark/deployment.nix)



## media-server\.shelfmark\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/media/shelfmark/deployment\.nix](../modules/server/media/shelfmark/deployment.nix)



## media-server\.shelfmark\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/media/shelfmark/deployment\.nix](../modules/server/media/shelfmark/deployment.nix)



## media-server\.shelfmark\.shelfmarkVolumeSize



Volume size for Shelfmark



*Type:*
string



*Default:*

```nix
"5Gi"
```

*Declared by:*
 - [modules/server/media/shelfmark/persistence\.nix](../modules/server/media/shelfmark/persistence.nix)



## media-server\.sonarr\.enable



Whether to enable Sonarr deployment on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/media/sonarr/default\.nix](../modules/server/media/sonarr/default.nix)



## media-server\.sonarr\.loadBalancerIP



MetalLB IP address for Sonarr



*Type:*
string



*Default:*

```nix
"192.168.1.202"
```

*Declared by:*
 - [modules/server/media/sonarr/services\.nix](../modules/server/media/sonarr/services.nix)



## media-server\.sonarr\.loadBalancerPort



MetalLB port for Sonarr



*Type:*
signed integer



*Default:*

```nix
8989
```

*Declared by:*
 - [modules/server/media/sonarr/services\.nix](../modules/server/media/sonarr/services.nix)



## media-server\.sonarr\.resources



Resource profile for Sonarr



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "1000m";
    memory = "512Mi";
  };
  requests = {
    cpu = "20m";
    memory = "128Mi";
  };
}
```

*Declared by:*
 - [modules/server/media/sonarr/deployment\.nix](../modules/server/media/sonarr/deployment.nix)



## media-server\.sonarr\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/media/sonarr/deployment\.nix](../modules/server/media/sonarr/deployment.nix)



## media-server\.sonarr\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/media/sonarr/deployment\.nix](../modules/server/media/sonarr/deployment.nix)



## media-server\.sonarr\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/media/sonarr/deployment\.nix](../modules/server/media/sonarr/deployment.nix)



## media-server\.sonarr\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/media/sonarr/deployment\.nix](../modules/server/media/sonarr/deployment.nix)



## media-server\.sonarr\.sonarrVolumeSize



Volume size for Sonarr



*Type:*
string



*Default:*

```nix
"5Gi"
```

*Declared by:*
 - [modules/server/media/sonarr/persistence\.nix](../modules/server/media/sonarr/persistence.nix)



## media-server\.transmission\.enable



Whether to enable Transmission deployment on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/media/transmission/default\.nix](../modules/server/media/transmission/default.nix)



## media-server\.transmission\.loadBalancerIP



MetalLB IP address for Transmission



*Type:*
string



*Default:*

```nix
"192.168.1.202"
```

*Declared by:*
 - [modules/server/media/transmission/services\.nix](../modules/server/media/transmission/services.nix)



## media-server\.transmission\.loadBalancerPeerPort



MetalLB port for Transmission peers



*Type:*
signed integer



*Default:*

```nix
51413
```

*Declared by:*
 - [modules/server/media/transmission/services\.nix](../modules/server/media/transmission/services.nix)



## media-server\.transmission\.loadBalancerPort



MetalLB port for Transmission



*Type:*
signed integer



*Default:*

```nix
9091
```

*Declared by:*
 - [modules/server/media/transmission/services\.nix](../modules/server/media/transmission/services.nix)



## media-server\.transmission\.resources



Resource profile for Transmission



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "1000m";
    memory = "512Mi";
  };
  requests = {
    cpu = "20m";
    memory = "128Mi";
  };
}
```

*Declared by:*
 - [modules/server/media/transmission/deployment\.nix](../modules/server/media/transmission/deployment.nix)



## media-server\.transmission\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/media/transmission/deployment\.nix](../modules/server/media/transmission/deployment.nix)



## media-server\.transmission\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/media/transmission/deployment\.nix](../modules/server/media/transmission/deployment.nix)



## media-server\.transmission\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/media/transmission/deployment\.nix](../modules/server/media/transmission/deployment.nix)



## media-server\.transmission\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/media/transmission/deployment\.nix](../modules/server/media/transmission/deployment.nix)



## media-server\.transmission\.transmissionVolumeSize



Volume size for Transmission



*Type:*
string



*Default:*

```nix
"5Gi"
```

*Declared by:*
 - [modules/server/media/transmission/persistence\.nix](../modules/server/media/transmission/persistence.nix)



## media-server\.transmission\.transmissionWatchVolumeSize



Volume size for Transmission’s watch directory



*Type:*
string



*Default:*

```nix
"5Gi"
```

*Declared by:*
 - [modules/server/media/transmission/persistence\.nix](../modules/server/media/transmission/persistence.nix)



## metallb\.enable



Whether to enable Metallb helm chart on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/metallb/default\.nix](../modules/server/metallb/default.nix)



## metallb\.addresses



List of IP addresses for MetalLB’s IP address pool\.



*Type:*
list of string



*Default:*

```nix
[
  "192.168.1.200-192.168.1.210"
]
```

*Declared by:*
 - [modules/server/metallb/settings\.nix](../modules/server/metallb/settings.nix)



## monitoring\.enable



Whether to enable prometheus, grafana and loki services on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/monitoring/default\.nix](../modules/server/monitoring/default.nix)



## monitoring\.alloy\.enable



Whether to enable Alloy helm chart on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/monitoring/alloy/default\.nix](../modules/server/monitoring/alloy/default.nix)



## monitoring\.alloy\.loadBalancerIP



MetalLB IP address for Alloy



*Type:*
string



*Default:*

```nix
"192.168.1.210"
```

*Declared by:*
 - [modules/server/monitoring/alloy/services\.nix](../modules/server/monitoring/alloy/services.nix)



## monitoring\.alloy\.loadBalancerPort



MetalLB port for Alloy



*Type:*
signed integer



*Default:*

```nix
12345
```

*Declared by:*
 - [modules/server/monitoring/alloy/services\.nix](../modules/server/monitoring/alloy/services.nix)



## monitoring\.alloy\.resources



Resource profile for Alloy



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "10m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/monitoring/alloy/settings\.nix](../modules/server/monitoring/alloy/settings.nix)



## monitoring\.alloy\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/alloy/settings\.nix](../modules/server/monitoring/alloy/settings.nix)



## monitoring\.alloy\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/alloy/settings\.nix](../modules/server/monitoring/alloy/settings.nix)



## monitoring\.alloy\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/alloy/settings\.nix](../modules/server/monitoring/alloy/settings.nix)



## monitoring\.alloy\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/alloy/settings\.nix](../modules/server/monitoring/alloy/settings.nix)



## monitoring\.grafana\.enable



Whether to enable Grafana helm chart on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/monitoring/grafana/default\.nix](../modules/server/monitoring/grafana/default.nix)



## monitoring\.grafana\.grafanaVolumeSize



Volume size for Grafana



*Type:*
string



*Default:*

```nix
"10Gi"
```

*Declared by:*
 - [modules/server/monitoring/grafana/persistence\.nix](../modules/server/monitoring/grafana/persistence.nix)



## monitoring\.grafana\.loadBalancerIP



MetalLB IP address for Grafana



*Type:*
string



*Default:*

```nix
"192.168.1.210"
```

*Declared by:*
 - [modules/server/monitoring/grafana/services\.nix](../modules/server/monitoring/grafana/services.nix)



## monitoring\.grafana\.loadBalancerPort



MetalLB port for Grafana



*Type:*
signed integer



*Default:*

```nix
3000
```

*Declared by:*
 - [modules/server/monitoring/grafana/services\.nix](../modules/server/monitoring/grafana/services.nix)



## monitoring\.grafana\.resources



Resource profile for Grafana



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "2000m";
    memory = "1Gi";
  };
  requests = {
    cpu = "50m";
    memory = "256Mi";
  };
}
```

*Declared by:*
 - [modules/server/monitoring/grafana/settings\.nix](../modules/server/monitoring/grafana/settings.nix)



## monitoring\.grafana\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/grafana/settings\.nix](../modules/server/monitoring/grafana/settings.nix)



## monitoring\.grafana\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/grafana/settings\.nix](../modules/server/monitoring/grafana/settings.nix)



## monitoring\.grafana\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/grafana/settings\.nix](../modules/server/monitoring/grafana/settings.nix)



## monitoring\.grafana\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/grafana/settings\.nix](../modules/server/monitoring/grafana/settings.nix)



## monitoring\.loki\.enable



Whether to enable Loki helm chart on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/monitoring/loki/default\.nix](../modules/server/monitoring/loki/default.nix)



## monitoring\.loki\.loadBalancerIP



MetalLB IP address for Loki



*Type:*
string



*Default:*

```nix
"192.168.1.210"
```

*Declared by:*
 - [modules/server/monitoring/loki/services\.nix](../modules/server/monitoring/loki/services.nix)



## monitoring\.loki\.loadBalancerPort



MetalLB port for Loki



*Type:*
signed integer



*Default:*

```nix
3100
```

*Declared by:*
 - [modules/server/monitoring/loki/services\.nix](../modules/server/monitoring/loki/services.nix)



## monitoring\.loki\.lokiCanaryResources



Resource profile for Loki Canary



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "10m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/monitoring/loki/settings\.nix](../modules/server/monitoring/loki/settings.nix)



## monitoring\.loki\.lokiCanaryResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/loki/settings\.nix](../modules/server/monitoring/loki/settings.nix)



## monitoring\.loki\.lokiCanaryResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/loki/settings\.nix](../modules/server/monitoring/loki/settings.nix)



## monitoring\.loki\.lokiCanaryResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/loki/settings\.nix](../modules/server/monitoring/loki/settings.nix)



## monitoring\.loki\.lokiCanaryResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/loki/settings\.nix](../modules/server/monitoring/loki/settings.nix)



## monitoring\.loki\.lokiResources



Resource profile for Loki



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "1000m";
    memory = "512Mi";
  };
  requests = {
    cpu = "20m";
    memory = "128Mi";
  };
}
```

*Declared by:*
 - [modules/server/monitoring/loki/settings\.nix](../modules/server/monitoring/loki/settings.nix)



## monitoring\.loki\.lokiResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/loki/settings\.nix](../modules/server/monitoring/loki/settings.nix)



## monitoring\.loki\.lokiResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/loki/settings\.nix](../modules/server/monitoring/loki/settings.nix)



## monitoring\.loki\.lokiResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/loki/settings\.nix](../modules/server/monitoring/loki/settings.nix)



## monitoring\.loki\.lokiResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/loki/settings\.nix](../modules/server/monitoring/loki/settings.nix)



## monitoring\.loki\.lokiVolumeSize



Volume size for Loki



*Type:*
string



*Default:*

```nix
"10Gi"
```

*Declared by:*
 - [modules/server/monitoring/loki/persistence\.nix](../modules/server/monitoring/loki/persistence.nix)



## monitoring\.prometheus\.enable



Whether to enable Prometheus helm chart on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/monitoring/prometheus/default\.nix](../modules/server/monitoring/prometheus/default.nix)



## monitoring\.prometheus\.alertManagerResources



Resource profile for Alert Manager



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "1000m";
    memory = "512Mi";
  };
  requests = {
    cpu = "20m";
    memory = "128Mi";
  };
}
```

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.alertManagerResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.alertManagerResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.alertManagerResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.alertManagerResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.alertmanagerVolumeSize



Volume size for Alert Manager



*Type:*
string



*Default:*

```nix
"10Gi"
```

*Declared by:*
 - [modules/server/monitoring/prometheus/persistence\.nix](../modules/server/monitoring/prometheus/persistence.nix)



## monitoring\.prometheus\.kubeMetricsResources



Resource profile for Prometheus’s kube-state-metrics agent



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "25m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.kubeMetricsResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.kubeMetricsResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.kubeMetricsResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.kubeMetricsResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.loadBalancerIP



MetalLB IP address for Prometheus



*Type:*
string



*Default:*

```nix
"192.168.1.210"
```

*Declared by:*
 - [modules/server/monitoring/prometheus/services\.nix](../modules/server/monitoring/prometheus/services.nix)



## monitoring\.prometheus\.loadBalancerPort

MetalLB port for Prometheus



*Type:*
signed integer



*Default:*

```nix
9090
```

*Declared by:*
 - [modules/server/monitoring/prometheus/services\.nix](../modules/server/monitoring/prometheus/services.nix)



## monitoring\.prometheus\.nodeExporterResources



Resource profile for Prometheus’s node exporter



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "25m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.nodeExporterResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.nodeExporterResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.nodeExporterResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.nodeExporterResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.operatorResources



Resource profile for Prometheus’s operator



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "25m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.operatorResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.operatorResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.operatorResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.operatorResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.prometheusResources



Resource profile for Prometheus



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "2000m";
    memory = "1Gi";
  };
  requests = {
    cpu = "50m";
    memory = "256Mi";
  };
}
```

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.prometheusResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.prometheusResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.prometheusResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.prometheusResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.prometheusVolumeSize



Volume size for Prometheus



*Type:*
string



*Default:*

```nix
"10Gi"
```

*Declared by:*
 - [modules/server/monitoring/prometheus/persistence\.nix](../modules/server/monitoring/prometheus/persistence.nix)



## monitoring\.prometheus\.thanosCompactorResources



Resource profile for Prometheus’s Thanos compactor



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "25m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/monitoring/prometheus/thanos-compactor\.nix](../modules/server/monitoring/prometheus/thanos-compactor.nix)



## monitoring\.prometheus\.thanosCompactorResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/thanos-compactor\.nix](../modules/server/monitoring/prometheus/thanos-compactor.nix)



## monitoring\.prometheus\.thanosCompactorResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/thanos-compactor\.nix](../modules/server/monitoring/prometheus/thanos-compactor.nix)



## monitoring\.prometheus\.thanosCompactorResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/thanos-compactor\.nix](../modules/server/monitoring/prometheus/thanos-compactor.nix)



## monitoring\.prometheus\.thanosCompactorResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/thanos-compactor\.nix](../modules/server/monitoring/prometheus/thanos-compactor.nix)



## monitoring\.prometheus\.thanosCompactorVolumeSize



Volume size for Prometheus’s Thanos compactor



*Type:*
string



*Default:*

```nix
"10Gi"
```

*Declared by:*
 - [modules/server/monitoring/prometheus/persistence\.nix](../modules/server/monitoring/prometheus/persistence.nix)



## monitoring\.prometheus\.thanosResources



Resource profile for Prometheus’s Thanos sidecar



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "25m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.thanosResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.thanosResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.thanosResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## monitoring\.prometheus\.thanosResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/monitoring/prometheus/settings\.nix](../modules/server/monitoring/prometheus/settings.nix)



## netbird\.enable



Whether to enable netbird client daemon\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/netbird\.nix](../modules/core/netbird.nix)



## netbird-operator\.enable



Whether to enable Netbird operator helm chart on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/netbird-operator/default\.nix](../modules/server/netbird-operator/default.nix)



## netbird-operator\.resources



Resource profile for Netbird Operator



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "25m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/netbird-operator/settings\.nix](../modules/server/netbird-operator/settings.nix)



## netbird-operator\.resources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/netbird-operator/settings\.nix](../modules/server/netbird-operator/settings.nix)



## netbird-operator\.resources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/netbird-operator/settings\.nix](../modules/server/netbird-operator/settings.nix)



## netbird-operator\.resources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/netbird-operator/settings\.nix](../modules/server/netbird-operator/settings.nix)



## netbird-operator\.resources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/netbird-operator/settings\.nix](../modules/server/netbird-operator/settings.nix)



## netbird-operator\.routerResources



Resource profile for Netbird Router



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "25m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/netbird-operator/router\.nix](../modules/server/netbird-operator/router.nix)



## netbird-operator\.routerResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/netbird-operator/router\.nix](../modules/server/netbird-operator/router.nix)



## netbird-operator\.routerResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/netbird-operator/router\.nix](../modules/server/netbird-operator/router.nix)



## netbird-operator\.routerResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/netbird-operator/router\.nix](../modules/server/netbird-operator/router.nix)



## netbird-operator\.routerResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/netbird-operator/router\.nix](../modules/server/netbird-operator/router.nix)



## networking\.enable



Whether to enable networking using networkmanager\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/networking\.nix](../modules/core/networking.nix)



## nextcloud\.enable



Whether to enable nextcloud helm chart on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/nextcloud/default\.nix](../modules/server/nextcloud/default.nix)



## nextcloud\.barmanResources



Resource profile for Nextcloud’s Barman backup sidecar



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "25m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/nextcloud/postgres\.nix](../modules/server/nextcloud/postgres.nix)



## nextcloud\.barmanResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/postgres\.nix](../modules/server/nextcloud/postgres.nix)



## nextcloud\.barmanResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/postgres\.nix](../modules/server/nextcloud/postgres.nix)



## nextcloud\.barmanResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/postgres\.nix](../modules/server/nextcloud/postgres.nix)



## nextcloud\.barmanResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/postgres\.nix](../modules/server/nextcloud/postgres.nix)



## nextcloud\.collaboraResources



Resource profile for Nextcloud’s Collabora instance



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "2000m";
    memory = "2Gi";
  };
  requests = {
    cpu = "100m";
    memory = "512Mi";
  };
}
```

*Declared by:*
 - [modules/server/nextcloud/settings\.nix](../modules/server/nextcloud/settings.nix)



## nextcloud\.collaboraResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/settings\.nix](../modules/server/nextcloud/settings.nix)



## nextcloud\.collaboraResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/settings\.nix](../modules/server/nextcloud/settings.nix)



## nextcloud\.collaboraResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/settings\.nix](../modules/server/nextcloud/settings.nix)



## nextcloud\.collaboraResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/settings\.nix](../modules/server/nextcloud/settings.nix)



## nextcloud\.cronJobResources



Resource profile for Nextcloud’s cron jobs



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "10m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/nextcloud/settings\.nix](../modules/server/nextcloud/settings.nix)



## nextcloud\.cronJobResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/settings\.nix](../modules/server/nextcloud/settings.nix)



## nextcloud\.cronJobResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/settings\.nix](../modules/server/nextcloud/settings.nix)



## nextcloud\.cronJobResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/settings\.nix](../modules/server/nextcloud/settings.nix)



## nextcloud\.cronJobResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/settings\.nix](../modules/server/nextcloud/settings.nix)



## nextcloud\.initdb\.enable



Whether to enable initialize fresh postgres database for Nextcloud\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/nextcloud/postgres\.nix](../modules/server/nextcloud/postgres.nix)



## nextcloud\.loadBalancerIP



MetalLB IP address for Nextcloud



*Type:*
string



*Default:*

```nix
"192.168.1.203"
```

*Declared by:*
 - [modules/server/nextcloud/services\.nix](../modules/server/nextcloud/services.nix)



## nextcloud\.loadBalancerPort



MetalLB port for Forgejo



*Type:*
signed integer



*Default:*

```nix
8080
```

*Declared by:*
 - [modules/server/nextcloud/services\.nix](../modules/server/nextcloud/services.nix)



## nextcloud\.nextcloudDataVolumeSize



Volume size for Nextcloud’s Collabora instance



*Type:*
string



*Default:*

```nix
"10Gi"
```

*Declared by:*
 - [modules/server/nextcloud/persistence\.nix](../modules/server/nextcloud/persistence.nix)



## nextcloud\.nextcloudResources



Resource profile for Nextcloud



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "2000m";
    memory = "2Gi";
  };
  requests = {
    cpu = "100m";
    memory = "512Mi";
  };
}
```

*Declared by:*
 - [modules/server/nextcloud/settings\.nix](../modules/server/nextcloud/settings.nix)



## nextcloud\.nextcloudResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/settings\.nix](../modules/server/nextcloud/settings.nix)



## nextcloud\.nextcloudResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/settings\.nix](../modules/server/nextcloud/settings.nix)



## nextcloud\.nextcloudResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/settings\.nix](../modules/server/nextcloud/settings.nix)



## nextcloud\.nextcloudResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/settings\.nix](../modules/server/nextcloud/settings.nix)



## nextcloud\.nextcloudVolumeSize



Volume size for Nextcloud



*Type:*
string



*Default:*

```nix
"10Gi"
```

*Declared by:*
 - [modules/server/nextcloud/persistence\.nix](../modules/server/nextcloud/persistence.nix)



## nextcloud\.postgresResources



Resource profile for Nextcloud’s CNPG database



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "2000m";
    memory = "2Gi";
  };
  requests = {
    cpu = "50m";
    memory = "256Mi";
  };
}
```

*Declared by:*
 - [modules/server/nextcloud/postgres\.nix](../modules/server/nextcloud/postgres.nix)



## nextcloud\.postgresResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/postgres\.nix](../modules/server/nextcloud/postgres.nix)



## nextcloud\.postgresResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/postgres\.nix](../modules/server/nextcloud/postgres.nix)



## nextcloud\.postgresResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/postgres\.nix](../modules/server/nextcloud/postgres.nix)



## nextcloud\.postgresResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/postgres\.nix](../modules/server/nextcloud/postgres.nix)



## nextcloud\.postgresVolumeSize



Volume size for Nextcloud’s Postgres Database



*Type:*
string



*Default:*

```nix
"8Gi"
```

*Declared by:*
 - [modules/server/nextcloud/persistence\.nix](../modules/server/nextcloud/persistence.nix)



## nextcloud\.redisExporterResources



Resource profile for Nextcloud’s cache metrics exporter



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "200m";
    memory = "128Mi";
  };
  requests = {
    cpu = "10m";
    memory = "32Mi";
  };
}
```

*Declared by:*
 - [modules/server/nextcloud/valkey\.nix](../modules/server/nextcloud/valkey.nix)



## nextcloud\.redisExporterResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/valkey\.nix](../modules/server/nextcloud/valkey.nix)



## nextcloud\.redisExporterResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/valkey\.nix](../modules/server/nextcloud/valkey.nix)



## nextcloud\.redisExporterResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/valkey\.nix](../modules/server/nextcloud/valkey.nix)



## nextcloud\.redisExporterResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/valkey\.nix](../modules/server/nextcloud/valkey.nix)



## nextcloud\.valkeyResources



Resource profile for Nextcloud’s cache



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "200m";
    memory = "256Mi";
  };
  requests = {
    cpu = "10m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/nextcloud/valkey\.nix](../modules/server/nextcloud/valkey.nix)



## nextcloud\.valkeyResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/valkey\.nix](../modules/server/nextcloud/valkey.nix)



## nextcloud\.valkeyResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/valkey\.nix](../modules/server/nextcloud/valkey.nix)



## nextcloud\.valkeyResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/valkey\.nix](../modules/server/nextcloud/valkey.nix)



## nextcloud\.valkeyResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/nextcloud/valkey\.nix](../modules/server/nextcloud/valkey.nix)



## node-feature-discovery\.enable



Whether to enable Node feature discovery helm chart on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/node-feature-discovery/default\.nix](../modules/server/node-feature-discovery/default.nix)



## node-feature-discovery\.gcResources



Resource profile for Node Feature Discovery’s garbage collector instance



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "200m";
    memory = "128Mi";
  };
  requests = {
    cpu = "5m";
    memory = "32Mi";
  };
}
```

*Declared by:*
 - [modules/server/node-feature-discovery/settings\.nix](../modules/server/node-feature-discovery/settings.nix)



## node-feature-discovery\.gcResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/node-feature-discovery/settings\.nix](../modules/server/node-feature-discovery/settings.nix)



## node-feature-discovery\.gcResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/node-feature-discovery/settings\.nix](../modules/server/node-feature-discovery/settings.nix)



## node-feature-discovery\.gcResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/node-feature-discovery/settings\.nix](../modules/server/node-feature-discovery/settings.nix)



## node-feature-discovery\.gcResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/node-feature-discovery/settings\.nix](../modules/server/node-feature-discovery/settings.nix)



## node-feature-discovery\.masterResources



Resource profile for Node Feature Discovery’s master instance



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "200m";
    memory = "128Mi";
  };
  requests = {
    cpu = "5m";
    memory = "32Mi";
  };
}
```

*Declared by:*
 - [modules/server/node-feature-discovery/settings\.nix](../modules/server/node-feature-discovery/settings.nix)



## node-feature-discovery\.masterResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/node-feature-discovery/settings\.nix](../modules/server/node-feature-discovery/settings.nix)



## node-feature-discovery\.masterResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/node-feature-discovery/settings\.nix](../modules/server/node-feature-discovery/settings.nix)



## node-feature-discovery\.masterResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/node-feature-discovery/settings\.nix](../modules/server/node-feature-discovery/settings.nix)



## node-feature-discovery\.masterResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/node-feature-discovery/settings\.nix](../modules/server/node-feature-discovery/settings.nix)



## node-feature-discovery\.workerResources



Resource profile for Node Feature Discovery’s worker instance



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "200m";
    memory = "128Mi";
  };
  requests = {
    cpu = "5m";
    memory = "32Mi";
  };
}
```

*Declared by:*
 - [modules/server/node-feature-discovery/settings\.nix](../modules/server/node-feature-discovery/settings.nix)



## node-feature-discovery\.workerResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/node-feature-discovery/settings\.nix](../modules/server/node-feature-discovery/settings.nix)



## node-feature-discovery\.workerResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/node-feature-discovery/settings\.nix](../modules/server/node-feature-discovery/settings.nix)



## node-feature-discovery\.workerResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/node-feature-discovery/settings\.nix](../modules/server/node-feature-discovery/settings.nix)



## node-feature-discovery\.workerResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/node-feature-discovery/settings\.nix](../modules/server/node-feature-discovery/settings.nix)



## postgres\.enable



Whether to enable Cloudnative-pg helm chart on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/database/postgres\.nix](../modules/server/database/postgres.nix)



## postgres\.barmanPluginResources



Resource profile for CNPG Barman plugin



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "25m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/database/postgres\.nix](../modules/server/database/postgres.nix)



## postgres\.barmanPluginResources\.limits\.cpu

CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/database/postgres\.nix](../modules/server/database/postgres.nix)



## postgres\.barmanPluginResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/database/postgres\.nix](../modules/server/database/postgres.nix)



## postgres\.barmanPluginResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/database/postgres\.nix](../modules/server/database/postgres.nix)



## postgres\.barmanPluginResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/database/postgres\.nix](../modules/server/database/postgres.nix)



## postgres\.operatorResources



Resource profile for CNPG operator



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "25m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/database/postgres\.nix](../modules/server/database/postgres.nix)



## postgres\.operatorResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/database/postgres\.nix](../modules/server/database/postgres.nix)



## postgres\.operatorResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/database/postgres\.nix](../modules/server/database/postgres.nix)



## postgres\.operatorResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/database/postgres\.nix](../modules/server/database/postgres.nix)



## postgres\.operatorResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/database/postgres\.nix](../modules/server/database/postgres.nix)



## printing\.enable



Whether to enable printing using CUPS\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/desktop/printing\.nix](../modules/desktop/printing.nix)



## qmk\.enable



Whether to enable QMK keyboard configuration\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/desktop/qmk\.nix](../modules/desktop/qmk.nix)



## scanning\.enable



Whether to enable scanning using SANE and installs necessary drivers for Epson Perfection V550 Scanner\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/desktop/scanning\.nix](../modules/desktop/scanning.nix)



## secrets\.enable



Whether to enable importing secrets using sops-nix\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/secrets\.nix](../modules/core/secrets.nix)



## secrets\.authorizedKeys\.enable



Whether to enable user authorized ssh keys\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/secrets\.nix](../modules/core/secrets.nix)



## secrets\.forgejo\.enable



Whether to enable forgejo secrets\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/forgejo/secrets\.nix](../modules/server/forgejo/secrets.nix)



## secrets\.freshrss\.enable



Whether to enable FreshRSS login secrets\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/freshrss/secrets\.nix](../modules/server/freshrss/secrets.nix)



## secrets\.garage\.enable



Whether to enable garage secrets\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/garage/secrets\.nix](../modules/server/garage/secrets.nix)



## secrets\.grafana\.enable



Whether to enable Grafana secrets\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/monitoring/grafana/secrets\.nix](../modules/server/monitoring/grafana/secrets.nix)



## secrets\.homepage\.enable



Whether to enable Homepage secrets\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/homepage/secrets\.nix](../modules/server/homepage/secrets.nix)



## secrets\.immich\.enable



Whether to enable Immich secrets\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/immich/secrets\.nix](../modules/server/immich/secrets.nix)



## secrets\.k3s\.enable



Whether to enable k3s token secret\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/k3s\.nix](../modules/server/k3s.nix)



## secrets\.loki\.enable



Whether to enable Loki secrets\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/monitoring/loki/secrets\.nix](../modules/server/monitoring/loki/secrets.nix)



## secrets\.longhorn\.enable



Whether to enable longhorn backup credentials secret\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/longhorn/secrets\.nix](../modules/server/longhorn/secrets.nix)



## secrets\.media-server\.enable



Whether to enable jellyfin, transmission and servarr secrets\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/media/secrets\.nix](../modules/server/media/secrets.nix)



## secrets\.netbird-operator\.enable



Whether to enable SOPS-managed OAuth secret for Netbird operator\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/netbird-operator/secrets\.nix](../modules/server/netbird-operator/secrets.nix)



## secrets\.nextcloud\.enable



Whether to enable Nextcloud secrets\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/nextcloud/secrets\.nix](../modules/server/nextcloud/secrets.nix)



## secrets\.passwords\.enable



Whether to enable user password secrets\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/secrets\.nix](../modules/core/secrets.nix)



## secrets\.prometheus\.enable



Whether to enable Prometheus secrets\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/monitoring/prometheus/secrets\.nix](../modules/server/monitoring/prometheus/secrets.nix)



## server\.resources\.profiles



Kubernetes resource profiles



*Type:*
attribute set of (submodule)



*Default:*

```nix
{
  appLarge = {
    limits = {
      cpu = "2000m";
      memory = "2Gi";
    };
    requests = {
      cpu = "100m";
      memory = "512Mi";
    };
  };
  appMedium = {
    limits = {
      cpu = "2000m";
      memory = "1Gi";
    };
    requests = {
      cpu = "50m";
      memory = "256Mi";
    };
  };
  appMini = {
    limits = {
      cpu = "500m";
      memory = "256Mi";
    };
    requests = {
      cpu = "10m";
      memory = "64Mi";
    };
  };
  appSmall = {
    limits = {
      cpu = "1000m";
      memory = "512Mi";
    };
    requests = {
      cpu = "20m";
      memory = "128Mi";
    };
  };
  cache = {
    limits = {
      cpu = "200m";
      memory = "256Mi";
    };
    requests = {
      cpu = "10m";
      memory = "64Mi";
    };
  };
  dbMedium = {
    limits = {
      cpu = "2000m";
      memory = "2Gi";
    };
    requests = {
      cpu = "50m";
      memory = "256Mi";
    };
  };
  dbSmall = {
    limits = {
      cpu = "1000m";
      memory = "512Mi";
    };
    requests = {
      cpu = "20m";
      memory = "128Mi";
    };
  };
  infraLarge = {
    limits = {
      cpu = "500m";
      memory = "256Mi";
    };
    requests = {
      cpu = "25m";
      memory = "64Mi";
    };
  };
  infraMedium = {
    limits = {
      cpu = "500m";
      memory = "256Mi";
    };
    requests = {
      cpu = "20m";
      memory = "48Mi";
    };
  };
  infraMini = {
    limits = {
      cpu = "200m";
      memory = "128Mi";
    };
    requests = {
      cpu = "5m";
      memory = "32Mi";
    };
  };
  infraSmall = {
    limits = {
      cpu = "200m";
      memory = "128Mi";
    };
    requests = {
      cpu = "10m";
      memory = "32Mi";
    };
  };
}
```

*Declared by:*
 - [modules/server/resource-profiles\.nix](../modules/server/resource-profiles.nix)



## server\.resources\.profiles\.\<name>\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/resource-profiles\.nix](../modules/server/resource-profiles.nix)



## server\.resources\.profiles\.\<name>\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/resource-profiles\.nix](../modules/server/resource-profiles.nix)



## server\.resources\.profiles\.\<name>\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/resource-profiles\.nix](../modules/server/resource-profiles.nix)



## server\.resources\.profiles\.\<name>\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/resource-profiles\.nix](../modules/server/resource-profiles.nix)



## ssh\.enable



Whether to enable ssh\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/ssh\.nix](../modules/core/ssh.nix)



## steam\.enable



Whether to enable steam gaming client\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/desktop/steam\.nix](../modules/desktop/steam.nix)



## theme\.enable



Whether to enable stylix theme\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.base16Scheme



tinted theming colour scheme



*Type:*
string



*Default:*

```nix
"default-dark"
```



*Example:*

```nix
"catppuccin-mocha"
```

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.fonts



Fonts used for interface, terminal and emojis



*Type:*
submodule



*Default:*

```nix
{ }
```

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## theme\.fonts\.emoji



The font to use for emoji



*Type:*
submodule



*Default:*

```nix
Noto Color Emoji
```

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

```nix
Inter
```

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

```nix
JetBrainsMono Nerd Font Mono
```

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

```nix
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

```nix
"dark"
```

*Declared by:*
 - [modules/core/theme\.nix](../modules/core/theme.nix)



## valkey-operator\.enable



Whether to enable valkey-operator helm chart on k3s\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/server/database/valkey-operator\.nix](../modules/server/database/valkey-operator.nix)



## valkey-operator\.operatorResources



Resource profile for Valkey operator



*Type:*
submodule



*Default:*

```nix
{
  limits = {
    cpu = "500m";
    memory = "256Mi";
  };
  requests = {
    cpu = "25m";
    memory = "64Mi";
  };
}
```

*Declared by:*
 - [modules/server/database/valkey-operator\.nix](../modules/server/database/valkey-operator.nix)



## valkey-operator\.operatorResources\.limits\.cpu



CPU core percentage limit



*Type:*
string

*Declared by:*
 - [modules/server/database/valkey-operator\.nix](../modules/server/database/valkey-operator.nix)



## valkey-operator\.operatorResources\.limits\.memory



Memory limit



*Type:*
string

*Declared by:*
 - [modules/server/database/valkey-operator\.nix](../modules/server/database/valkey-operator.nix)



## valkey-operator\.operatorResources\.requests\.cpu



Requested CPU core percentage



*Type:*
string

*Declared by:*
 - [modules/server/database/valkey-operator\.nix](../modules/server/database/valkey-operator.nix)



## valkey-operator\.operatorResources\.requests\.memory



Requested memory



*Type:*
string

*Declared by:*
 - [modules/server/database/valkey-operator\.nix](../modules/server/database/valkey-operator.nix)



## virtualisation\.enable



Whether to enable virtualisation using libvirt \& qemu\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/desktop/virtualisation\.nix](../modules/desktop/virtualisation.nix)



## zsh\.enable



Whether to enable zsh\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/zsh\.nix](../modules/core/zsh.nix)


