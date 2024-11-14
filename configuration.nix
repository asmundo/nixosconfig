# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  sources = import ./nix/sources.nix;

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./packages.nix
      ./networking.nix
      ./services.nix
      ./desktop.nix
      ./users.nix
    ];

    # Configure the Nix package manager
  nixpkgs = {
    overlays = [ (import sources.emacs-overlay) ];
    pkgs = import sources.nixos {
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "openssl-1.1.1w"
          "openssl-1.1.1m"
        ];
      };
    };
  };

  documentation.enable = false;
  nix = {
    # tools to non default version
    #package = pkgs.nix_2_3;
    extraOptions = ''
      netrc-file = /etc/nix/netrc
      experimental-features = nix-command
      log-quiet = true
    '';
    settings = {
      trusted-users = [ "aos" ];
      max-jobs = "auto";
    };
  };


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  systemd = {
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };

    # We need to optimize disk usage on regular intervals
    # link optimize
    services.nix-store-optimize = {
      description = "optimize nix store 'nix-store --optimise'";
      startAt = "*-*-* 02:00:00";
      script = ''
        ${pkgs.nix}/bin/nix-store --optimise
     '';
    };
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "no";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "no";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # security.pam.services.gdm.enableGnomeKeyring = true;
  security = {
    sudo.extraConfig = ''
      Defaults        timestamp_timeout=30
    '';
  };

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aos = {
    isNormalUser = true;
    description = "Åsmund Østvold";
    extraGroups = [ "networkmanager"
                    "wheel"
                    "libvirtd"
                    "docker"
                  ];
    packages = with pkgs; [
      firefox
      nixos-option
      gitFull
      pass
      gnupg
      aws-workspaces
      screen
      niv
    ];
  };

  programs = {
    bash = {
      blesh.enable = true;
      promptInit = ''
          if [[ $USER != "root" ]]; then
             source ${pkgs.git.out}/share/bash-completion/completions/git-prompt.sh
             PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
             GIT_PS1_SHOWDIRTYSTATE=true
             GIT_PS1_SHOWUNTRACKEDFILES=true
             GIT_PS1_SHOWUPSTREAM="verbose"
             PS1='%\w $(__git_ps1 "(%s) ")% '
          fi
          ble-bind -f 'M-C-?' kill-backward-cword
          HISTFILESIZE=5000
          HISTSIZE=5000

          nix-d ()
          {
              nix-diff --color always  --character-oriented $(echo $1 | sed 's/\" -> \"/ /')
          }
          nix-dd ()
          {
              nix-diff --color always  $(echo $1 | sed 's/\" -> \"/ /')
          }
          tplan ()
          {
              (
                  set -e
                  set -o pipefail
                  local failed=0
                  PLAN=/tmp/tplan$$.log
                  OUTPUT=/tmp/tplan_$$.output.txt
                  terraform plan --out $PLAN | tee $OUTPUT
                  if ! grep -q "No changes" /tmp/; then
                     local drvs=$(awk -F\" '/nixos_drv/ {print $4, $6}' $OUTPUT)
                     echo $drvs
                     if (($(echo $drvs | wc -w) == 2)); then
                        (cat $OUTPUT; nix-diff --character-oriented --color always $drvs ) | less --quit-if-one-screen
                     fi

                     read -p "Do you want to execute the TERRAFORM APPLY? (y/n) " answer

                     # Check the answer
                     if [ "$answer" = "y" ]; then
                         # Execute the HAPPY command
                         echo "Executing terraform plan command..."
                         terraform apply $PLAN
                     fi
                  fi
              )
          }
        source $(${pkgs.findutils}/bin/find '${pkgs.emacsPackages.vterm}' -name 'emacs-vterm-bash.sh')
       '';
       shellInit = ''
        source $(${pkgs.findutils}/bin/find '${pkgs.emacsPackages.vterm}' -name 'emacs-vterm-bash.sh')
      '';
    };
    git = {
      enable = true;
      prompt.enable = true;

      config = {
        user = {
          email = "aos@resoptima.com";
          name = "Åsmund Østvold";
        };
        aliases = {
          root = "rev-parse --show-toplevel";
          lastb = "! git reflog | grep -o 'checkout: moving from .* to ' | sed -e 's/checkout: moving from //' -e 's/ to $//' | head -20";
        };
        core = {
          pager = "less -F -X";
        };
        pull.rebase = true;
        rebase.autoStash = true;
      };
    };
    direnv = {
      enable = true;
    };
  };


  virtualisation = {
    # this is needed to get a bridge with DHCP enabled
    libvirtd.enable = true;
  };

  # Emacs
  services.emacs = {
    enable = true;
    install = true;
    package = import ./emacs.nix { inherit pkgs; };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    aws-workspaces
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
