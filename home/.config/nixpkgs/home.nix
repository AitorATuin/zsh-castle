{ pkgs, ... }:

{
  home.packages = [
    pkgs.mpv
    pkgs.weechat
    pkgs.tig
    pkgs.neovim
    pkgs.cabal-install
    pkgs.cabal2nix
    pkgs.stack
    pkgs.virtmanager
    pkgs.docker-machine
    pkgs.docker-machine-kvm
    pkgs.glibcLocales
    pkgs.exercism
    pkgs.lnav
    pkgs.qrencode
  ];

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.magit
    ];
  };
  programs.home-manager = {
    enable = true;
    path = https://github.com/rycee/home-manager/archive/master.tar.gz;
  };
}
