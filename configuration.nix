{ config, lib, pkgs, inputs, ... }:
{
  imports = [
  ./hardware-configuration.nix
  inputs.home-manager.nixosModules.home-manager 
];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    users.zhenya = {
      imports = [ ./home.nix ];
    };
  };
  users.users.zhenya = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  networking.hostName = "penis"; # Define your hostname.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Europe/Bratislava";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
  #  packages = with pkgs; [ terminus-font ];
    keyMap = "us";
 #   useXkbConfig = true; # use xkb.options in tty.
   };


 # services.power-profiles-daemon.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time";
      };
    };
};

  hardware.graphics.enable = true;
  #boot.initrd.kernelModules = [ "vmwgfx" ];
  #services.xserver.videoDrivers = [ "vmwgfx" ];

  programs.uwsm = {
    enable = true;
  };
  programs.hyprland.withUWSM = true;
  programs.hyprland.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;


   programs.firefox.enable = true;
   environment.systemPackages = with pkgs; [
     vim 
     telegram-desktop
     wget
     git
     neofetch
     #power-profiles-daemon
     #lenovo-legion
     xfce.thunar
     lxappearance
     catppuccin
   ];
nixpkgs.config.allowUnfree = true;
services.xserver.videoDrivers = ["nvidia"];
hardware.nvidia = {
  modesetting.enable = true;

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

  system.stateVersion = "25.05"; # Did you read the comment?
}

