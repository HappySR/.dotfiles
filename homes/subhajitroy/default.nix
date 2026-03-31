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

    # Youtube Music (!HardwareMediaKeyHandling)
    (pkgs.runCommand "pear-desktop-fixed"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
        # Since we are using pkgs.pear-desktop directly and not a 'src',
        # we tell Nix not to look for a source folder to unpack.
        dontUnpack = true;
      }
      ''
        mkdir -p $out/bin

        # Wrap the binary with the hardware media key flag
        makeWrapper ${pkgs.pear-desktop}/bin/pear-desktop $out/bin/pear-desktop \
          --add-flags "--disable-features=HardwareMediaKeyHandling"

        # Copy the desktop files and icons
        cp -r ${pkgs.pear-desktop}/share $out/share
        chmod -R +w $out/share

        # Fix the Exec path in all desktop files to point to our new wrapped binary
        find $out/share/applications -name "*.desktop" -exec sed -i "s|Exec=pear-desktop|Exec=$out/bin/pear-desktop|g" {} +
      ''
    )
    pkgs.sunshine
    pkgs.bibata-cursors
    # programs
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
    pkgs.flutter335
    pkgs.foliate
    pkgs.fish-lsp
    pkgs.gcc
    pkgs.google-chrome
    pkgs.inotify-tools
    pkgs.jq
    pkgs.just
    pkgs.kdePackages.kconfig
    pkgs.kdePackages.karousel
    pkgs.kdePackages.kde-gtk-config
    pkgs.legcord
    pkgs.libreoffice-qt-fresh
    pkgs.mongodb
    pkgs.mpv
    pkgs.markdown-oxide
    pkgs.nodejs
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
    pkgs.pnpm
    pkgs.podman-compose
    pkgs.python313
    pkgs.python313Packages.pip
    pkgs.python313Packages.pandas
    pkgs.quickemu
    pkgs.ripgrep
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
    pkgs.yaml-language-server
    pkgs.zathura
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
