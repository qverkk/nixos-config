{ pkgs, ... }:

{
 services.spotifyd = {
   enable = true;
   settings = {
     global = {
       device_name = "DesktopNix";
       username_cmd = "${pkgs.coreutils}/bin/head -1 /run/agenix/spotify-username";
       password_cmd = "${pkgs.coreutils}/bin/head -1 /run/agenix/spotify-password";
       bitrate = 320;
     };
   };
 };
}