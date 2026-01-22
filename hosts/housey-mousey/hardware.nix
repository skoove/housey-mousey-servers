{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ata_piix" "uhci_hcd" "hpsa" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.loader.grub.device = "/dev/disk/by-id/scsi-3600508b1001c8be2401fe60c1629957b";

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";
  };

  fileSystems."/mnt/data_part_1" = {
    device = "/dev/disk/by-label/data_part_1";
    fsType = "ext4";
    options = [ "users" "exec" ];
  };

  fileSystems."/mnt/data_part_2" = {
    device = "/dev/disk/by-label/data_part_2";
    fsType = "ext4";
    options = [ "users" "exec" ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
