{ config, pkgs, ... }:

{
  networking = {
    firewall = {
      enable = false;
      # enable = true;
      allowPing = true;
      # allowedTCPPorts = [ 42000 ];
      # checkReversePath = "loose";
    };
    hostName = "desktop";
    networkmanager.enable = true;
  };

  # enable the tailscale service
  services.tailscale.enable = true;
  services.sshd.enable = true;

  programs.wireshark.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
}
