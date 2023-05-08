# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./tritonus-hardware.nix
    ./common.nix
  ];

  networking = {
    hostName = "tritonus";
    interfaces.enp6s0.useDHCP = true;
  };

  hardware.amdgpu = {
    amdvlk = false;
    loadInInitrd = true;
  };

  system.stateVersion = "23.05"; # Did you read the comment? nah.
}

