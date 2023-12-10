{
  config,
  pkgs,
  ...
}: {
  # imports = [
  #   ../../../optional/home-manager/kanshi.nix
  # ];

  imports =
    [
      ../../programs/wayland/bars/eww/home.nix
      # ../../programs/wayland/bars/waybar/home.nix
    ]
    ++ (import ../../programs/wayland)
    ++ (import ../../theme/catppuccin-dark/wayland);

  wayland.windowManager.sway = {
    enable = true;
    extraOptions = ["--unsupported-gpu"];
    wrapperFeatures.gtk = true;
    systemd = {
      enable = true;
    };
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
      menu = "~/.config/rofi/launcher.sh";
    };
    extraConfigEarly = ''
      # default gaps
      gaps inner 5
      gaps outer 0

      for_window [class="^.*"] border pixel 1
      # new_window 1pixel
      default_border none

      # colors
      client.background n/a #434c5e n/a
      client.focused #434c5e #434c5e #eceff4 #434c5e #434c5e
      client.focused_inactive #3b4252 #3b4252 #eceff4 #3b4252 #3b4252
      client.unfocused #3b4252 #3b4252 #eceff4 #3b4252 #3b4252
      client.urgent #434c5e #434c5e #eceff4 #434c5e #434c5e
      bar {
          swaybar_command eww open bar &
          # workspace_buttons yes
      }

      # Volume
      bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_SINK@ 5%-
      bindsym XF86AudioRaiseVolume exec wpctl set-volume @DEFAULT_SINK@ 5%+
      bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_SINK@ toggle

      # Brightness
      bindsym XF86MonBrightnessDown exec brightnessctl set 10%-
      bindsym XF86MonBrightnessUp exec brightnessctl set 10%+

      # Music
      bindsym XF86AudioPlay exec playerctl play-pause
      bindsym XF86AudioPrev exec playerctl previous
      bindsym XF86AudioNext exec playerctl next

      input 1739:31251:SYNA2393:00_06CB:7A13_Touchpad {
          tap enabled
          drag enabled
      }
    '';
  };

  home.packages = with pkgs; [
    swayidle
    # mako
  ];

  programs.swaylock.settings = {
    color = "353935";
    font-size = 24;
    indicator-idle-visible = false;
    indicator-radius = 100;
    line-color = "ffffff";
    show-failed-attempts = true;
  };
}
