# Convert config.monitors into hyprland's format
{
  lib,
  monitors,
}: let
  inherit (builtins) concatStringsSep map toString;
in
  concatStringsSep "\n" (
    map
    (m: ''
      monitor=${m.name},${
        if m.modeline == ""
        then "${toString m.width}x${toString m.height}@${toString m.refreshRate}"
        else "modeline ${m.modeline}"
      },${toString m.x}x${toString m.y},${m.scale}
      ${lib.optionalString (m.workspace != null) "workspace=${m.name},${m.workspace}"}
    '')
    monitors
  )
