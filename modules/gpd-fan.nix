{ config, lib, pkgs, ... }:

with lib;

let

  gpd-fan = config.boot.kernelPackages.callPackage ../pkgs/linux/gpd-fan.nix { };

in
{

  meta.maintainers = [ maintainers.Cryolitia ];

  ###### interface

  options = {
      hardware.gpd-fan.enable = mkEnableOption "Enable GPD deices fan driver";
  };

  ###### implementation

  config = mkIf config.hardware.gpd-fan.enable {
    boot.extraModulePackages = [ gpd-fan ];
    boot.kernelModules = [ "gpd_fan" ];
  };
}
