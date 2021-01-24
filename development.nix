{ config, pkgs, ...}:
{
  programs.git = {
    enable = true;
    userName = "Pauli Kauro";
    userEmail = "3965357+paulikauro@users.noreply.github.com";
  };
}
