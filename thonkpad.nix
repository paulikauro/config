{ config, pkgs, lib, theUsername, ... }:
{
  # TODO: packages-module?
  imports = [
    ./thonkpad-hardware.nix
    ./common.nix
  ];
  services.openssh = {
    enable = false;
  };
  #services.openvpn.servers = {
  #  testi.config = '' config /local/vpn.conf '';
  #};

  networking = {
    hostName = "thonkpad";
    interfaces = {
      enp2s0.useDHCP = false;
      wlp3s0.useDHCP = false;
    };
  };

  hardware.amdgpu = {
    # this failed to compile shaders for whatever reason
    amdvlk.enable = false;
    # this seems to be the default but to be explicit
    initrd.enable = true;
  };

  # amd pstate?
  # fingerprint reader usb id 27c6:55a4

  system.stateVersion = "23.05"; # Did you read the comment? I didn't.
}

