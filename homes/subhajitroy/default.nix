{ pkgs, ... }:

{
  # General home stuff.
  home.username = "subhajitroy";
  home.homeDirectory = "/home/subhajitroy";
  home.stateVersion = "25.05"; # DO NOT CHANGE!
  home.packages = [
    # themes and icons
    (pkgs.catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "mauve" ];
      winDecStyles = [ "classic" ];
    })
    pkgs.bibata-cursors
    # programs
    pkgs.aseprite
    pkgs.android-studio
    pkgs.codebook
    pkgs.deno
    pkgs.distrobox
    (pkgs.bottles.override {
      removeWarningPopup = true;
    })
    pkgs.fd
    pkgs.ferium
    pkgs.ffmpeg
    pkgs.flutter
    pkgs.foliate
    pkgs.fish-lsp
    pkgs.google-chrome
    pkgs.inotify-tools
    pkgs.jq
    pkgs.just
    pkgs.kdePackages.kconfig
    pkgs.kdePackages.karousel
    pkgs.kdePackages.kde-gtk-config
    pkgs.legcord
    pkgs.libreoffice-qt-fresh
    pkgs.mpv
    pkgs.markdown-oxide
    pkgs.nvd
    pkgs.nixd
    pkgs.nix-alien
    pkgs.nix-search-tv
    pkgs.nixfmt-rfc-style
    pkgs.nix-output-monitor
    pkgs.obsidian
    (pkgs.prismlauncher.override {
      jdks = [ pkgs.jdk21 ];
    })
    pkgs.pika-backup
    pkgs.podman-compose
    pkgs.quickemu
    pkgs.ripgrep
    pkgs.ryubing
    pkgs.ripgrep-all
    pkgs.simple-completion-language-server
    pkgs.taplo
    pkgs.typst
    pkgs.tinymist
    pkgs.typstyle
    pkgs.unzip
    pkgs.unrar
    pkgs.vscode
    pkgs.vscode-langservers-extracted
    pkgs.wl-clipboard
    pkgs.youtube-music
    pkgs.yaml-language-server
    pkgs.zathura
    pkgs.zed-editor-fhs
    # fonts
    pkgs.maple-mono.NF
  ];

  # Fontconfig stuff.
  fonts.fontconfig.enable = true;

  # Let home-manager update itself.
  programs.home-manager.enable = true;

  # Allow unfree.
  nixpkgs.config.allowUnfree = true;

  # Catppuccin!
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  # Modules.
  imports = [
    ./bat.nix
    ./direnv.nix
    ./eza.nix
    ./fish.nix
    ./flatpak.nix
    ./fzf.nix
    ./ghostty.nix
    ./git.nix
    ./gpg.nix
    ./helix.nix
    ./jujutsu.nix
    ./kdeconnect.nix
    ./firefox.nix
    ./niri.nix
    ./nushell.nix
    ./obs-studio.nix
    ./starship.nix
    ./yazi.nix
    ./zellij.nix
    ./zoxide.nix
  ];
}
