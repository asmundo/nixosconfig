{ config, lib, pkgs, ... }:

{
  fonts = {
    fontconfig = {
      enable = true;
      antialias = true;
    };
    fontDir.enable = true;
    packages = with pkgs; [
      corefonts
      jetbrains-mono
      font-awesome_5
      dejavu_fonts
      source-code-pro
    ];
  };
  environment = {
    variables = {
      DOTNET_ROOT = with pkgs.dotnetCorePackages; combinePackages ([
        sdk_6_0
        sdk_7_0
      ]);
    };
  };
}
