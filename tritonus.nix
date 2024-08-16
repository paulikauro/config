# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./tritonus-hardware.nix
    ./common.nix
  ];

  services.openssh = {
    enable = false;
  };

  networking = {
    hostName = "tritonus";
    interfaces.enp6s0.useDHCP = false;
  };

  hardware.amdgpu = {
    amdvlk.enable = false;
    initrd.enable = true;
  };

  system.stateVersion = "23.05"; # Did you read the comment? nah.
}

