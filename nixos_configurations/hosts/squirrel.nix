# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  networking.hostName = "squirrel";

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };
  boot.initrd.availableKernelModules = [ "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" "rbd" ];
  boot.extraModulePackages = [ ];

  boot.kernel.sysctl."fs.inotify.max_user_instances" = 524288;
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;

  fileSystems."/" =
    { device = "/dev/disk/by-label/root";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "ext4";
    };

  swapDevices = [ ];

  services.udev.extraRules = ''SUBSYSTEM=="net", ATTR{address}=="00:1b:21:78:ce:1e", NAME="eth0"'';
  networking = {
    interfaces."eth0" = {
      ipv4.addresses = [{
        address = "148.251.135.212";
        prefixLength = 27;
      }];
      ipv6.addresses = [{
        address = "2a01:4f8:210:34f4::2";
        prefixLength = 64;
      }];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    defaultGateway = "148.251.135.193";

    nameservers = [
      "185.12.64.1"
      "185.12.64.2"
      "2a01:4ff:ff00::add:1"
      "2a01:4ff:ff00::add:2"
    ];
  };


  services.k3s = {
    enable = true;
    extraFlags = "--disable traefik --disable local-storage --disable metrics-server";
  };
  networking.firewall = {
    allowedTCPPorts = [ 80 6443 ];
    extraCommands = ''
      iptables -A nixos-fw -p tcp --source 10.0.0.0/8 --dport 10250 -j nixos-fw-accept
      iptables -A nixos-fw -p tcp --source 10.0.0.0/8 --dport 9100 -j nixos-fw-accept
    '';
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
