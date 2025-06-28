{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.hardware.intelgpu;

  useIntelVaapiDriver = cfg.vaapiDriver == "intel-vaapi-driver" || cfg.vaapiDriver == null;
  intel-vaapi-driver = (pkgs.intel-vaapi-driver or pkgs.vaapiIntel).override {
    enableHybridCodec = cfg.enableHybridCodec;
  };
  intel-vaapi-driver-32 =
    (pkgs.driversi686Linux.intel-vaapi-driver or pkgs.driversi686Linux.vaapiIntel).override
      {
        enableHybridCodec = cfg.enableHybridCodec;
      };

  useIntelOcl =
    useIntelVaapiDriver
    && (config.hardware.enableAllFirmware or config.nixpkgs.config.allowUnfree or false);
  intel-ocl = pkgs.intel-ocl;

  useIntelMediaDriver = cfg.vaapiDriver == "intel-media-driver" || cfg.vaapiDriver == null;
  intel-media-driver = pkgs.intel-media-driver;
  intel-media-driver-32 = pkgs.driversi686Linux.intel-media-driver;
  intel-compute-runtime = pkgs.intel-compute-runtime;
  vpl-gpu-rt = pkgs.vpl-gpu-rt or pkgs.onevpl-intel-gpu;
in
{
  services.fstrim.enable = lib.mkDefault true;
  services.xserver.dpi = 189;
  services.thermald.enable = lib.mkDefault true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;

    dynamicBoost.enable = true;
    open = false;
    nvidiaSettings = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  boot.initrd.kernelModules = [ "nvidia" ] ++ lib.optionals cfg.loadInInitrd [ cfg.driver ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.lenovo-legion-module
    config.boot.kernelPackages.nvidia_x11
  ];

  hardware.graphics.extraPackages =
    lib.optionals useIntelVaapiDriver [ intel-vaapi-driver ]
    ++ lib.optionals useIntelOcl [ intel-ocl ]
    ++ lib.optionals useIntelMediaDriver [
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];

  hardware.graphics.extraPackages32 =
    lib.optionals useIntelVaapiDriver [ intel-vaapi-driver-32 ]
    ++ lib.optionals useIntelMediaDriver [ intel-media-driver-32 ];

  assertions = [
    {
      assertion = (
        cfg.driver != "xe" || lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.8"
      );
      message = "Intel Xe GPU driver is not supported on kernels earlier than 6.8. Update or use the i915 driver.";
    }
  ];

  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
  '';

  # services.udev.extraRules = ''
  #   # Remove NVIDIA USB xHCI Host Controller devices, if present
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"

  #   # Remove NVIDIA USB Type-C UCSI devices, if present
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"

  #   # Remove NVIDIA Audio devices, if present
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

  #   # Remove NVIDIA VGA/3D controller devices
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  # '';
  # boot.blacklistedKernelModules = [
  #   "nouveau"
  #   "nvidia"
  #   "nvidia_drm"
  #   "nvidia_modeset"
  # ];

  #hardware.nvidia.primeBatterySaverSpecialisation = true;
  specialisation = lib.mkIf config.hardware.nvidia.primeBatterySaverSpecialisation {
    battery-saver.configuration = {
      system.nixos.tags = [ "battery-saver" ];
      imports = [
        # Leave only the integrated GPU enabled
        ./disable.nix
      ];
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce false;

        prime.offload.enableOffloadCmd = lib.mkForce false;
        powerManagement = {
          enable = lib.mkForce false;
          finegrained = lib.mkForce false;
        };
      };
    };
  };
}
