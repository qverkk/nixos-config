{}: ''
  exec-once=mako
  exec-once=hyprpaper
  exec-once=eww open bar

  misc {
      disable_hyprland_logo = true
      animate_mouse_windowdragging = false
      animate_manual_resizes = false
	  vfr = true
  }

  # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
  input {
      kb_layout = pl

      follow_mouse = 1

      touchpad {
          natural_scroll = false
      }

      sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
  }

  general {
      gaps_in = 5
      gaps_out = 5
      border_size = 2
      col.active_border = rgb(FFF0F5)
      col.inactive_border = rgba(595959aa)

      layout = dwindle
  }

  decoration {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more

      rounding = 10
	  blur {
		enabled = false
		size = 3
		passes = 1
		new_optimizations = true
	  }

      drop_shadow = false
      shadow_range = 4
      shadow_render_power = 3
      col.shadow = rgba(1a1a1aee)
  }

  animations {
      enabled = false
      animation = border, 1, 2, default
      animation = fade, 1, 4, default
      animation = windows, 1, 3, default, popin 80%
      animation = workspaces, 1, 2, default, slide
  }

  dwindle {
      pseudotile = true
      preserve_split = true
      force_split = 2
      use_active_for_splits = false
  }

  master {
      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      new_is_master = true
  }

  gestures {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      workspace_swipe = false
  }

  # Example per-device config
  # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
  device:epic mouse V1 {
      sensitivity = -0.5
  }

  # Example windowrule v1
  # windowrule = float, ^(kitty)$
  # Example windowrule v2
  # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
  # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


  # See https://wiki.hyprland.org/Configuring/Keywords/ for more
  $mainMod = SUPER
  $mainModShift = SUPER_SHIFT

  # Fix jetbrains
  windowrulev2 = rounding 0, xwayland:1, floating:1
  windowrulev2 = center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|splash)$
  windowrulev2 = size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$
  windowrulev2 = float,floating:0,class:^(jetbrains-.*),title:^(win.*)
  windowrulev2 = float,class:^(jetbrains-.*),title:^(Welcome to.*)
  windowrulev2 = center,class:^(jetbrains-.*),title:^(Replace All)$
  windowrulev2 = forceinput,class:^(jetbrains-.*)
  windowrulev2 = noanim,class:^(jetbrains-.*)
  windowrulev2 = windowdance,class:^(jetbrains-.*) # allows IDE to move child windows

  # keepass
  windowrulev2 = float,class:^(org.keepassxc.KeePassXC)$,title:^(KeePassXC - Browser Access Request)$

  # flameshot
  # windowrulev2 = noanim,class:^(flameshot)^,title:^(flameshot)^
  # bind = $mainMod, print, exec, flameshot gui
  bind = $mainMod, print, exec, grimblast copy area
  bind = $mainMod SHIFT, print, exec, grimblast copy area && wl-paste | tesseract -l "eng+pol" stdin stdout | wl-copy && notify-send "$(wl-paste)"

  # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
  bind = $mainMod, return, exec, kitty zsh
  bind = $mainMod, space, exec, ~/.config/rofi/launcher.sh
  bind = $mainMod SHIFT, E, exit,
  bind = $mainMod, E, exec, dolphin

  bind = $mainMod, Q, killactive,
  bind = $mainMod, V, togglefloating,
  bind = $mainMod, J, togglesplit, # dwindle
  bind = $mainMod, F, fullscreen,
  bind = $mainMod, G, togglegroup,
  bind = $mainMod, TAB, changegroupactive, f
  bind = $mainMod SHIFT, TAB, changegroupactive, b
  bind = $mainMod, P, pseudo, # dwindle
  bind = $mainMod, L, exec, swaylock

  # Move focus with mainMod + arrow keys
  bind = $mainMod, left, movefocus, l
  bind = $mainMod, right, movefocus, r
  bind = $mainMod, up, movefocus, u
  bind = $mainMod, down, movefocus, d

  # Move window with mainMod + shift + arrow keys
  bind = $mainModShift, left, movewindow, l
  bind = $mainModShift, right, movewindow, r
  bind = $mainModShift, up, movewindow, u
  bind = $mainModShift, down, movewindow, d

  # Switch workspaces with mainMod + [0-9]
  bind = $mainMod, 1, workspace, 1
  bind = $mainMod, 2, workspace, 2
  bind = $mainMod, 3, workspace, 3
  bind = $mainMod, 4, workspace, 4
  bind = $mainMod, 5, workspace, 5
  bind = $mainMod, 6, workspace, 6
  bind = $mainMod, 7, workspace, 7
  bind = $mainMod, 8, workspace, 8
  bind = $mainMod, 9, workspace, 9
  bind = $mainMod, 0, workspace, 10

  # Move active window to a workspace with mainMod + SHIFT + [0-9]
  bind = $mainMod SHIFT, 1, movetoworkspace, 1
  bind = $mainMod SHIFT, 2, movetoworkspace, 2
  bind = $mainMod SHIFT, 3, movetoworkspace, 3
  bind = $mainMod SHIFT, 4, movetoworkspace, 4
  bind = $mainMod SHIFT, 5, movetoworkspace, 5
  bind = $mainMod SHIFT, 6, movetoworkspace, 6
  bind = $mainMod SHIFT, 7, movetoworkspace, 7
  bind = $mainMod SHIFT, 8, movetoworkspace, 8
  bind = $mainMod SHIFT, 9, movetoworkspace, 9
  bind = $mainMod SHIFT, 0, movetoworkspace, 10

  # Scroll through existing workspaces with mainMod + scroll
  bind = $mainMod, mouse_down, workspace, e+1
  bind = $mainMod, mouse_up, workspace, e-1

  # Move/resize windows with mainMod + LMB/RMB and dragging
  bindm = $mainMod, mouse:272, movewindow
  bindm = $mainMod, mouse:273, resizewindow

  # Volume
  bindl=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
  bindl=, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
  bindl=, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

  # Brightness
  bindl=, XF86MonBrightnessDown, exec, brightnessctl 10%-
  bindl=, XF86MonBrightnessUp, exec, brightnessctl 10%+

  # Music
  bindl=, XF86AudioPlay, exec, playerctl play-pause
  bindl=, XF86AudioPrev, exec, playerctl previous
  bindl=, XF86AudioNext, exec, playerctl next

  # Brightness
  bindl=, XF86MonBrightnessDown, exec, brightnessctl set 5%-
  bindl=, XF86MonBrightnessUp, exec, brightnessctl set +5%
''
