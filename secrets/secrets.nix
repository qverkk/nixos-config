let
  desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOK3hib19t1dgGlUxhMyoD81t4wYOO1UUvtLVnTCYwhD membersy@gmail.com";
in
{
  "spotify-username.age".publicKeys = [ desktop ];
  "spotify-password.age".publicKeys = [ desktop ];
}
