{ config, pkgs, ... }:

{
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  services.emacs.defaultEditor = true;
}
