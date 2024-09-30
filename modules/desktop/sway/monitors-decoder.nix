{ monitors }:
let
  inherit (builtins)
    fromJSON
    concatStringsSep
    map
    toString
    ;
in
fromJSON "{${
  concatStringsSep "," (
    map (m: ''
      "${m.name}": {
      	"pos": "${toString m.x} ${toString m.y}",
      	"mode": ${
         if m.custom == "" then
           ''"${toString m.width}x${toString m.height}@${toString m.refreshRate}Hz"''
         else
           "--custom ${m.custom}"
       },
      	"scale": "${m.scale}"
      }
    '') monitors
  )
}}"
