{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    ./uhardware.nix
    ./uhardware-options.nix
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
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  networking.hostName = "penis"; # Define your hostname.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  time.timeZone = "Europe/Bratislava";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    #  packages = with pkgs; [ terminus-font ];
    keyMap = "us";
    #   useXkbConfig = true; # use xkb.options in tty.
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time";
      };
    };
  };

  hardware.graphics.enable = true;
  programs.uwsm = {
    enable = true;
  };

  programs.hyprland.withUWSM = true;
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  #programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    gcc
    vim
    abaddon
    furmark
    csharp-ls
    omnisharp-roslyn
    csharpier
    telegram-desktop
    (dotnetCorePackages.combinePackages [
      dotnetCorePackages.sdk_10_0-bin
      dotnetCorePackages.sdk_9_0_3xx
    ])
    wget
    git
    neofetch
    #power-profiles-daemon
    #lenovo-legion
    xfce.thunar
    lxappearance
    catppuccin
    nixd
  ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05"; # Did you read the comment?
}
