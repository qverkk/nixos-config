{ ... }:
{
  home.file.zellij-default-layout = {
    target = ".config/zellij/layout_default.kdl";
    text = ''
      layout {
         default_tab_template {
              children
              pane size=1 borderless=true {
                  plugin location="zellij:tab-bar"
              }
          }
          tab
      }
    '';
  };

  home.file.zellij = {
    target = ".config/zellij/config.kdl";
    text = ''
            default_mode "normal"

            keybinds clear-defaults=true {
                tmux {
                    bind "n" { NewTab; SwitchToMode "normal"; }
                    bind "r" { SwitchToMode "renametab"; TabNameInput 0; }
                    bind "d" { Detach; }
                    bind "q" { Quit; }
                    bind "Esc" { SwitchToMode "normal"; }
                 }

                renametab {
                    bind "Ctrl c" { SwitchToMode "normal"; }
                    bind "Enter" { SwitchToMode "normal"; }
                    bind "Esc" { UndoRenameTab; SwitchToMode "normal"; }
                }

                normal {
                    bind "Ctrl b" { SwitchToMode "tmux"; }
                    bind "Alt !" { GoToTab 1; }
                    bind "Alt @" { GoToTab 2; }
                    bind "Alt #" { GoToTab 3; }
                    bind "Alt $" { GoToTab 4; }
                    bind "Alt %" { GoToTab 5; }
                    bind "Alt H" { GoToPreviousTab; }
                    bind "Alt L" { GoToNextTab; }
                }
            }

            simplified_ui true
            pane_frames false


      layout_dir "/home/qverkk/.config/zellij/"
      default_layout "layout_default"

            theme "carbonfox"
            themes {
                dracula {
                    fg 248 248 242
                    bg 40 42 54
                    red 255 85 85
                    green 80 250 123
                    yellow 241 250 140
                    blue 98 114 164
                    magenta 255 121 198
                    orange 255 184 108
                    cyan 139 233 253
                    black 0 0 0
                    white 255 255 255
                }
                carbonfox {
              	  bg "#161616"
                    fg "#f2f4f8"
                    red "#ee5396"
                    green "#25be6a"
                    blue "#78a9ff"
                    yellow "#08bdba"
                    magenta "#be95ff"
                    orange "#3ddbd9"
                    cyan "#33b1ff"
                    black "#353535"
                    white "#b6b8bb"
                }
            }


            default_shell "zsh"
            mouse_mode true
            scroll_buffer_size 8192
            copy_command "wl-copy"
            copy_on_select true
            mirror_session false
    '';
  };
  programs.zellij = {
    enable = true;
  };
}
