{ config, pkgs, ...}:
{
  home.packages = with pkgs; [
    clojure
    clojure-lsp
    haskell-language-server
    ghc
    maven
    zip
    unzip
  ];
  programs.git = {
    enable = true;
    userName = "Pauli Kauro";
    userEmail = "3965357+paulikauro@users.noreply.github.com";
  };
}
