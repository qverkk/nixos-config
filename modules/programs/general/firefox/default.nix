{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr;
    policies = {
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
      SearchEngines = {
        Add = [
          {
            Name = "Searx";
            Description = "Decentralized search engine";
            Alias = "sx";
            Method = "GET";
            URLTemplate = "https://searx.be/search?q={searchTerms}";
          }
          {
            Name = "Brave";
            Description = "Brave search engine";
            Alias = "br";
            Method = "GET";
            URLTemplate = "https://search.brave.com/search?q={searchTerms}";
          }
          {
            Name = "Sourcegraph/Nix";
            Description = "Sourcegraph nix search";
            Alias = "!snix";
            Method = "GET";
            URLTemplate = "https://sourcegraph.com/search?q=context:global+file:.nix%24+{searchTerms}&patternType=literal";
          }
          {
            Name = "Github/Nix";
            Description = "Github nix search";
            Alias = "!gnix";
            Method = "GET";
            URLTemplate = "https://github.com/search?q=language%3ANix+{searchTerms}&type=code";
          }
          {
            Name = "nixpkgs";
            Description = "Nixpkgs query";
            Alias = "!nix";
            Method = "GET";
            URLTemplate = "https://search.nixos.org/packages?&query={searchTerms}";
          }
        ];
        Default = "Brave";
        Remove = [
          "Google"
          "Bing"
          "Amazon.com"
          "eBay"
          "Twitter"
          "DuckDuckGo"
          "Wikipedia (en)"
        ];
      };
    };

    profiles = {
      qverkk = {
        id = 0;
        name = "qverkk";
        isDefault = true;
        settings = {
          "browser.sessionstore.resume_from_crash" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.purge_trackers.enabled" = true;
          # "privacy.resistFingerprinting" = true; # this doesn't allow websites to follow system theme

          # # webrtc
          "media.peerconnection.ice.default_address_only" = true;
          "media.peerconnection.enabled" = true;
          "toolkit.telemetry.enabled" = false;
          # "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org"; # no need for this if we follow system theme
          "privacy.donottrackheader.enabled" = true;
          "browser.startup.page" = 3; # Restore previous session
        };

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          clearurls
          vimium
          decentraleyes
          privacy-badger
          keepassxc-browser
        ];
      };
      work = {
        id = 1;
        isDefault = false;
      };
    };
  };
}
