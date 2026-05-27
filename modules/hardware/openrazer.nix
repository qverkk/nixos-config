{ config, pkgs, ... }:
let
  openrazerKernel = config.boot.kernelPackages.openrazer.overrideAttrs (oldAttrs: {
    postPatch =
      (oldAttrs.postPatch or "")
      + pkgs.lib.optionalString (pkgs.lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.18") ''
        if grep -q 'hid_report_raw_event(hdev, HID_INPUT_REPORT, xdata, sizeof(xdata), 0);' driver/razerkbd_driver.c; then
          substituteInPlace driver/razerkbd_driver.c \
            --replace-fail \
              'hid_report_raw_event(hdev, HID_INPUT_REPORT, xdata, sizeof(xdata), 0);' \
              'hid_report_raw_event(hdev, HID_INPUT_REPORT, xdata, sizeof(xdata), sizeof(xdata), 0);'
        fi
      '';
  });
in
{
  hardware.openrazer.enable = true;
  hardware.openrazer.packages.kernel = openrazerKernel;
  environment.systemPackages = with pkgs; [ openrazer-daemon ];
}
