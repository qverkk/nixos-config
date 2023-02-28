{ inputs, pkgs, ... }:

{
  imports = [
    ../features/desktop/sway
  ];

  monitors = [
    {
      name = "DP-0";
      width = 3440;
      height = 1440;
      isPrimary = true;
      refreshRate = 144;
      x = 0;
      workspace = "1";
    }
  ];
}
