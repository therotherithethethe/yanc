# /etc/nixos/home.nix (ВРЕМЕННЫЙ)
{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:

{
  imports = [
    ./modules/hyprland.nix
    ./modules/git.nix
    #./modules/gtk.nix
    #inputs.stylix.homeManagerModules.stylix
    ./modules/stylix.nix
  ];
  wayland.windowManager.sway = {

    extraOptions = [
      "--unsupported-gpu"
    ];
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+q" = "kill";
        };
      input = {

        "*" = {
          xkb_layout = "us,ru,ua,sk";
          xkb_options = "grp:ctrl_space_toggle,caps:escape";
        };

        "13652:64009:Compx_2.4G_Wireless_Receiver" = {
          repeat_delay = "250";
          repeat_rate = "30";
        };
      };
      terminal = "${pkgs.kitty}/bin/kitty";
      bars = [ ];
      modifier = "Mod4";
      defaultWorkspace = "workspace number 1";
      output = {
        eDP-1 = {
          scale = "2";
        };
      };
    };
  };
  programs.zoxide.enable = true;
  home.stateVersion = "25.05";
  programs.btop.enable = true;
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
    };
  };
  programs.wofi.enable = true;
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = "* { min-height: 0; font-size: 11px; } ";
    #style = builtins.readFile ./modules/waybar-style.css;
    # settings = {
    #   mainBar = {
    #     height = 30;
    #   };
    # };
  };
  programs.fish = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/.dotfiles/";
    };
  };

  home.packages = with pkgs; [ nixfmt-rfc-style ];
  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraConfig = builtins.readFile ./helixConf.toml;
    # --- ИЗМЕНЕНИЯ ЗДЕСЬ ---
    languages = {
      language = [
        {
          name = "nix";
          formatter = {
            command = "nixfmt";
          };
          auto-format = true;
        }
        {
          auto-format = true;
          name = "c-sharp";
          formatter = {
            command = "csharp-ls";
          };
        }
        {
          auto-format = true;
          name = "html";
          formatter = {
            command = "prettier";
            args = [
              "--parser"
              "html"
            ];
          };
        }
      ];
    };
    # --- КОНЕЦ ИЗМЕНЕНИЙ ---
  };
  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.hackneyed;
    size = 100;
    hyprcursor.enable = true;
  };
  home.sessionVariables = {
    DOTNET_ROOT = "/nix/store/75v9l3h97qrj4p0j8k6pf9hspdg0y3l2-dotnet-combined/share/dotnet";
    # This tells all Qt applications to try running on Wayland first

    #    QT_QPA_PLATFORM = "wayland";
    # Fixes blurry fonts on some apps
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    QT_QPA_PLATFORM = "wayland";
  };
  programs.vesktop.enable = true;
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = "48.72415410089862";
    longitude = "21.254198050207247";
  };
  programs.firefox = {
    enable = true;
    profiles = {
      "diufku38.default" = {
        isDefault = true;
        extensions.force = true;
      };
    };
  };

}
