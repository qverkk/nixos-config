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
          SponsoredTopSites = false;
          SponsoredPocket = false;
          Snippets = false;
          TopSites = false;
          Highlights = false;
        };
        Cookies = {
          RejectTracker = true;
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
        settings = {
          "browser.sessionstore.resume_from_crash" = true;
          "privacy.trackingprotection.enabled" = true;
          "browser.startup.page" = 3; # Restore previous session
        };
      };
      work = {
        id = 1;
        isDefault = false;
      };
    };
  };
}
