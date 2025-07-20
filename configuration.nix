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
  programs.nix-ld.enable = true;
  services.flatpak.enable = true;
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
    waylandCompositors = {
      sway = {
        prettyName = "Sway";
        comment = "Sway compositor managed by UWSM";
        binPath = "/etc/profiles/per-user/zhenya/bin/sway";
      };
    };
  };

  programs.hyprland.withUWSM = true;
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  #programs.firefox.enable = true;

  nixpkgs.overlays = [
    (import ./overlays/rawtherapee-overlay.nix)
  ];
  environment.systemPackages = with pkgs; [
    rawtherapee
    clang
    gcc
    tree
    c3c
    cmake
    rustup
    tealdeer
    tldr
    fd
    mako
    qbittorrent-enhanced
    nodePackages.prettier
    ncspot
    ilspycmd
    unzip
    yazi
    ripgrep
    neovim-unwrapped
    vim
    abaddon
    furmark
    # csharp-ls
    omnisharp-roslyn
    csharpier
    telegram-desktop
    (dotnetCorePackages.combinePackages [
      # dotnetCorePackages.sdk_10_0-bin
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
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamescope.enable = true;
  system.stateVersion = "25.05"; # Did you read the comment?
}
