{ pkgs, config, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
        FirefoxHome = {
          Search = true;
          Pocket = false;
          #              Snippets = false;
          #              TopSites = false;
          #              Highlights = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
    };
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      clearurls
      vimium
      decentraleyes
      privacy-badger
      keepassxc-browser
    ];

    profiles = {
      qverkk = {
        id = 0;
        name = "qverkk";
        isDefault = true;
      };
      work = {
        id = 1;
        isDefault = false;
      };
    };
  };
}
