{
  config,
  pkgs,
  ...
}: let
  monitor-setup = import ./monitors-decoder.nix {
    inherit (config) monitors;
  };
in {
  # imports = [
  #   ../../../optional/home-manager/kanshi.nix
  # ];

  imports =
    [
      ../../programs/wayland/bars/eww/home.nix
      # ../../programs/wayland/bars/waybar/home.nix
    ]
    ++ (import ../../programs/wayland/home.nix)
    ++ (import ../../theme/catppuccin-dark/wayland/home.nix);
  programs.i3status-rust = {
    enable = true;
    bars.top = {
      blocks = [
        {
          block = "net";
          device = "(en|wl).*";
          format = " $icon  ";
          format_alt = " $icon{ $ssid $signal_strength|}  ";
          missing_format = "";
        }
        {
          block = "sound";
          step_width = 5;
        }
        {
          block = "cpu";
          interval = 1;
          format = " $utilization ";
        }
        {
          block = "temperature";
          format = " $averange ";
        }
        {
          block = "memory";
          format = " $mem_used.eng(p:Mi)/$mem_total.eng(p:Mi) ";
        }
        {
          block = "battery";
          format = " $percentage $power $time ";
          missing_format = "";
        }
        {
          block = "time";
          interval = 60;
          format = " $timestamp.datetime(f:'%a %F %R') ";
        }
      ];
      # icons = "awesome6";
      settings.theme.overrides.separator = "<span font='13.5'>|</span>";
    };
  };

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
      output = monitor-setup;
      bars = [
        {
          position = "top";
          statusCommand = "i3status-rs ~/.config/i3status-rust/config-top.toml";
        }
      ];
      keybindings = {
        "${modifier}+Return" = "exec ${terminal}";

        # kill focused window
        "${modifier}+q" = "kill";

        # reload the configuration file
        "${modifier}+Shift+c" = "reload";

        # restart inplace (preserves your layout/session, can be used to upgrade i3)
        "${modifier}+Shift+r" = "restart";

        # start menu (a program launcher)
        "${modifier}+Space" = "exec ${menu}";

        # exit
        "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

        "${modifier}+t" = "border normal";
        "${modifier}+y" = "border 1pixel";
        "${modifier}+u" = "border none";
        "${modifier}+b" = "border toggle";

        # change focus
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        # move focused window
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        # split in horizontal orientation
        "${modifier}+x" = "split h";

        # split in vertical orientation
        "${modifier}+z" = "split v";

        # enter fullscreen mode for the focused container
        "${modifier}+f" = "fullscreen toggle";

        # change container layout (stacked, tabbed, toggle split)
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        # change between 2 recent workspaces
        "${modifier}+Tab" = "workspace back_and_forth";

        # focus the parent container
        "${modifier}+Shift+a" = "focus parent";

        # focus the child container
        "${modifier}+Shift+d" = "focus child";

        # toggle tiling / floating
        "${modifier}+Shift+space" = "floating toggle";

        # Make the currently focused window a scratchpad
        "${modifier}+Shift+BackSpace" = "move scratchpad";

        # Show the first scratchpad window
        "${modifier}+BackSpace" = "scratchpad show";

        # switch to workspace
        "${modifier}+1" = "workspace 1";
        "${modifier}+2" = "workspace 2";
        "${modifier}+3" = "workspace 3";
        "${modifier}+4" = "workspace 4";
        "${modifier}+5" = "workspace 5";
        "${modifier}+6" = "workspace 6";
        "${modifier}+7" = "workspace 7";
        "${modifier}+8" = "workspace 8";
        "${modifier}+9" = "workspace 9";
        "${modifier}+0" = "workspace 10";

        # move focused container to workspace
        "${modifier}+Shift+1" = "move container to workspace 1";
        "${modifier}+Shift+2" = "move container to workspace 2";
        "${modifier}+Shift+3" = "move container to workspace 3";
        "${modifier}+Shift+4" = "move container to workspace 4";
        "${modifier}+Shift+5" = "move container to workspace 5";
        "${modifier}+Shift+6" = "move container to workspace 6";
        "${modifier}+Shift+7" = "move container to workspace 7";
        "${modifier}+Shift+8" = "move container to workspace 8";
        "${modifier}+Shift+9" = "move container to workspace 9";
        "${modifier}+Shift+0" = "move container to workspace 10";

        "${modifier}+r" = "mode \"resize\"";

        # Volume
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 5%-";
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 5%+";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_SINK@ toggle";

        # Brightness
        "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set 10%+";

        # Music
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioPrev" = "exec playerctl previous";
        "XF86AudioNext" = "exec playerctl next";

        # Screenshot
        "${modifier}+Print" = "exec grim -g \"$(slurp -d)\" - | wl-copy -t image/png";
      };
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
