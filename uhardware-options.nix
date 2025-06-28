{ lib, ... }:
{
  options = {
    hardware.nvidia.primeBatterySaverSpecialisation = lib.mkEnableOption "configure a specialisation which turns on NVIDIA Prime battery saver";
  };
  options.hardware.intelgpu = {
    driver = lib.mkOption {
      description = "Intel GPU driver to use";
      type = lib.types.enum [
        "i915"
        "xe"
      ];
      default = "i915";
    };

    loadInInitrd =
      lib.mkEnableOption "Load the Intel GPU kernel module at stage 1 boot. (Added to `boot.initrd.kernelModules`)"
      // {
        default = true;
      };

    vaapiDriver = lib.mkOption {
      description = "Intel VAAPI driver to use (use null to use both)";
      type = lib.types.nullOr (
        lib.types.enum [
          "intel-vaapi-driver"
          "intel-media-driver"
        ]
      );
      default = null; # Use both drivers when we don't know which one to use
    };

    enableHybridCodec = lib.mkEnableOption "hybrid codec support for Intel GPUs";
  };
}
