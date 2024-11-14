# This file contains configuration for packages to install.
# It does not contain configuration for software that is already covered
# by otherlinux NixOS options (e.g. emacs)

{ config, pkgs, lib, ... }:

let
  dotnet = with pkgs; (dotnetCorePackages.combinePackages (with dotnetCorePackages; [
    sdk_6_0
    sdk_7_0
    sdk_8_0
    runtime_6_0
    runtime_7_0
    runtime_8_0
  ]));

in {

  # Allow program to have normal ld search paths
  programs.nix-ld.enable = true;

  # ... and declare packages to be installed.
  environment.systemPackages = with pkgs; [
    aws-workspaces
    azure-cli
    azure-storage-azcopy
    binutils-unwrapped
    blueman
    breeze-icons
    cachix
    cinny-desktop
    cmake
    curl
    direnv
    dolphin
    element-desktop
    fsautocomplete
    ffmpeg
    file
    gcc
    gimp
    flameshot
    gitFull
    gnome.nautilus
    gnumake
    google-chrome
    google-cloud-sdk
    grobi
    gtk3
    hsetroot
    htop
    hybridreverb2
    i3lock
    inetutils
    inotify-tools
    ispell
    jq
    killall
    kind
    kubectl
    kubelogin
    libnotify
    libtool
    lingot
    lnav
    man-pages
    nginx
    nheko
    nix-diff
    nix-index
    nixpkgs-fmt
    nodejs
    ntfs3g
    numix-cursor-theme
    numix-icon-theme
    numix-solarized-gtk-theme
    nushell
    okular
    openjdk
    pavucontrol
    postgresql
    proton-caller
    remmina
    ripgrep
    signal-desktop
    slack
    spotify
    sqlite
    sshpass
    openssl
    pkg-config
    tailscale
    tdesktop
    transmission
    tree
    unzip
    vlc
    weechat
    wget
    which
    xclip
    xsecurelock
    zstd
    jfrog-cli
    gdb
    trivy
    semgrep

    libreoffice
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.nb

    # Rust packages
    rustc
    cargo
    rustup
    rust-analyzer
    cargo-license

    # Python packages
    python3
    python3Packages.pip

    # Nix packages
    nil
    niv
    nix-diff
    nix-index
    nixpkgs-fmt
#    rnix-lsp

    # CLisp packages
    sbcl
    # lispPackages.quicklisp

    numix-cursor-theme
    numix-icon-theme
    numix-solarized-gtk-theme
    breeze-icons

    # vscode stuff
    vscode
    vscode-extensions.rust-lang.rust-analyzer

    # .NET packages
    dotnet
    (fsautocomplete.overrideDerivation (o: { dotnet-runtime = dotnet; }))
    fsharp
];
}
