{ config, ... }:
let
  colors = config.lib.stylix.colors;
in
{
  services.mako.enable = false;

  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 400;
        height = "(0, 150)";
        offset = "(8, 8)";
        origin = "top-right";
        corner_radius = 10;
        frame_width = 2;
        padding = 10;
        horizontal_padding = 20;
        gap_size = 8;
        separator_height = 2;
        separator_color = "frame";
        font = "CaskaydiaCove Nerd Font 12";
        format = "<b>%s</b>\\n%b";
        markup = "full";
      };

      urgency_low = {
        background = "#${colors.base01}";
        foreground = "#${colors.base05}";
        frame_color = "#${colors.base03}";
        highlight = "#${colors.base0D}";
        timeout = 6;
      };

      urgency_normal = {
        background = "#${colors.base01}";
        foreground = "#${colors.base05}";
        frame_color = "#${colors.base03}";
        highlight = "#${colors.base0E}";
        timeout = 10;
      };

      urgency_critical = {
        background = "#${colors.base01}";
        foreground = "#${colors.base06}";
        frame_color = "#${colors.base08}";
        highlight = "#${colors.base08}";
        timeout = 0;
      };
    };
  };
}
