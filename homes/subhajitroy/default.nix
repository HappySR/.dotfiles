{ pkgs, ... }:

{
  # General home stuff.
  home.username = "subhajitroy";
  home.homeDirectory = "/home/subhajitroy";
  home.stateVersion = "25.05"; # DO NOT CHANGE!
  home.packages = [

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
    # programs
    pkgs.android-studio
    pkgs.claude-code
    pkgs.codebook
    pkgs.distrobox
    pkgs.fd
    pkgs.ffmpeg
    pkgs.flutter335
    pkgs.foliate
    pkgs.fish-lsp
    pkgs.google-chrome
    pkgs.inotify-tools
    pkgs.jq
    pkgs.just
    pkgs.kdePackages.breeze-icons
    pkgs.kdePackages.kiconthemes
    pkgs.kdePackages.kconfig
    pkgs.kdePackages.karousel
    pkgs.kdePackages.kde-gtk-config
    pkgs.legcord
    pkgs.libreoffice-qt-fresh
    pkgs.markdown-oxide
    pkgs.mpv
    pkgs.nvd
    pkgs.nixd
    pkgs.nix-alien
    pkgs.nix-search-tv
    pkgs.nixfmt
    pkgs.nix-output-monitor
    pkgs.pika-backup
    pkgs.podman-compose
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
    ./kdeconnect.nix
    ./firefox.nix
    ./matugen.nix
    ./niri.nix
    ./nushell.nix
    ./obs-studio.nix
    ./starship.nix
    ./yazi.nix
    ./zoxide.nix
  ];
}
