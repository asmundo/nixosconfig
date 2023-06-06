{ config, pkgs, lib, ... }:

{
  users.extraUsers.aos = {
    extraGroups = [
      "libvirtd"
      "wireshark"
      "wheel"
    ];
    description = "Åsmund Østvold";
    isNormalUser = true;
  };
}
