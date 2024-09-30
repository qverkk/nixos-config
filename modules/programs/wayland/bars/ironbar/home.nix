{ pkgs, ... }:
{
  home.packages = with pkgs; [ ironbar ];

  xdg.configFile."ironbar/config.json".text =
    # json
    ''
      {
        "name": "main",
        "position": "top",
        "anchor_to_edges": true,

        "start": [
          {
            "type": "workspaces",
            "icon_size": 16,
            "all_monitors": true
          }
        ],

        "end": [
          {
            "type": "tray"
          },
          {
            "type": "clock",
            "format": "%x %a %R"
          }
        ]
      }
    '';
}
