{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  mkPrefs =
    attrs:
    let
      toPrefsValue =
        value:
        if builtins.isBool value then
          if value then "true" else "false"
        else if builtins.isInt value then
          toString value
        else if builtins.isString value then
          ''"${value}"''
        else
          throw "Type value not supported: ${builtins.typeOf value}";

      prefsLines = lib.mapAttrsToList (
        name: value: ''user_pref("${name}", ${toPrefsValue value});''
      ) attrs;
    in
    lib.concatStringsSep "\n" prefsLines;
in
{
  home = {
    packages = [
      inputs.zen-browser.packages.${pkgs.system}.default
    ];

    # file.".zen/default/extensions" = {
    #   source =
    #     let
    #       env = pkgs.buildEnv {
    #         name = "zen-extensions";
    #         paths = with pkgs.firefoxAddons; [
    #           vimium-ff
    #           hyper-read
    #           ublock-origin
    #           refined-github-
    #           rust-search-extension
    #           bitwarden-password-manager
    #         ];
    #       };
    #     in
    #     "${env}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}";
    #   recursive = true;
    #   force = true;
    # };
    file = {
      ".zen/profiles.ini".text = lib.generators.toINI { } {
        General = {
          StartWithLastProfile = 1;
          Version = 2;
        };

        Profile0 = {
          Name = "Default";
          Path = "default";
          IsRelative = 1;
          ZenAvatarPath = "chrome://browser/content/zen-avatars/avatar-46.svg";
          Default = 1;
        };
      };
      ".zen/default/search.json.mozlz4" = {
        force = true;
        source =
          let
            settings = {
              version = 6;
              force = true;
              default = "DuckDuckGo";
              order = [
                "DuckDuckGo"
                "Google"
              ];
              engines = {
                "MyNixOs" = {
                  urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
                  icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "nx" ];
                };
                "Bing".metaData.hidden = true;
                "Google".metaData.alias = "g"; # builtin engines only support specifying one additional alias
              };

            };
          in
          pkgs.runCommand "search.json.mozlz4"
            {
              nativeBuildInputs = with pkgs; [ mozlz4a ];
              json = builtins.toJSON settings;
            }
            ''
              mozlz4a <(echo "$json") "$out"
            '';
      };

      ".zen/default/user.js".text = mkPrefs {
        # Disable auto update
        "app.update.auto" = false;
        "app.update.enabled" = false;
        "app.update.silent" = false;
        "app.update.lastUpdateTime.background-update-timer" = 0;
        "app.update.lastUpdateTime.browser-cleanup-thumbnails" = 0;
        "app.update.lastUpdateTime.search-engine-update-timer" = 0;

        # Privacity and Security
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "browser.contentblocking.category" = "strict";
        "network.cookie.cookieBehavior" = 1; # Disable other cookies
        "browser.safebrowsing.malware.enabled" = true;
        "browser.safebrowsing.phishing.enabled" = true;

        # Performance
        "gfx.webrender.all" = true;
        "layers.acceleration.force-enabled" = true;
        "browser.cache.disk.enable" = false;
        "browser.cache.memory.enable" = true;

        # User Experience
        "browser.tabs.loadInBackground" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.bookmark" = true;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.search.suggest.enabled" = false;
        "browser.startup.page" = 3; # Restore last session
        "browser.newtabpage.enabled" = false;

        # Customization
        # "browser.uidensity" = 1; # Compact UI
        "devtools.chrome.enabled" = true;
        "devtools.debugger.remote-enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        # "browser.startup.homepage" = "https://self.host/homepage";

        # Disable telemetry
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;

        # Zen
        "zen.welcomeScreen.seen" = true;
        "zen.view.sidebar-expanded.show-button" = false;
        "zen.keyboard.shortcuts" =
          "{\"zenSplitViewGrid\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"G\"},\"zenSplitViewVertical\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"V\"},\"zenSplitViewHorizontal\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"H\"},\"zenSplitViewClose\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"U\"},\"zenChangeWorkspace\":{\"ctrl\":true,\"alt\":false,\"shift\":true,\"meta\":false,\"key\":\"E\"},\"zenToggleCompactMode\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"C\"},\"zenToggleCompactModeSidebar\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"S\"},\"zenToggleCompactModeToolbar\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"T\"},\"zenToggleWebPanels\":{\"ctrl\":true,\"alt\":false,\"shift\":true,\"meta\":false,\"key\":\"P\"},\"openScreenCapture\":{\"ctrl\":true,\"alt\":false,\"shift\":false,\"meta\":false,\"key\":\"s\"},\"openNewPrivateWindow\":{\"ctrl\":true,\"alt\":false,\"shift\":true,\"meta\":false,\"key\":\"N\"}}";
      };
    };

  };

  # programs.chromium = {
  #   enable = true;
  #   extensions = [
  #     "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
  #     "oboonakemofpalcgghocfoadofidjkkk" # keepassxc
  #     "ldgfbffkinooeloadekpmfoklnobpien" # raindrop
  #     "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
  #     "mdjildafknihdffpkfmmpnpoiajfjnjd" # consent o matic
  #     "lckanjgmijmafbedllaakclkaicjfmnk" # clear urls
  #     "ldpochfccmkkmhdbclfhpagapcfdljkj" # decentraleyes
  #     "gbmgphmejlcoihgedabhgjdkcahacjlj" # wallabag
  #   ];
  #   extraOpts = {
  #     "BrowserSignin" = 0;
  #     "BookmarkBarEnabled" = false;
  #     "SyncDisabled" = true;
  #     "PasswordManagerEnabled" = false;
  #     "PasswordSharingEnabled" = false;
  #     "SpellcheckEnabled" = true;
  #     "SpellcheckLanguage" = [
  #       "pl"
  #       "en-US"
  #     ];
  #     "ClearBrowsingDataOnExitList" = [ "password_signin" ];
  #     "RestoreOnStartup" = 1;
  #     "ShowHomeButton" = false;
  #     "BrowserLabsEnabled" = false;
  #     "AdsSettingForIntrusiveAdsSites" = 2;
  #     "GoogleSearchSidePanelEnabled" = false;
  #     "SearchSuggestEnabled" = false;
  #     "DefaultSearchProviderEnabled" = true;
  #     "DefaultSearchProviderAlternateURLs" = [
  #       "https://search.brave.com/search?q={searchTerms}"
  #       "https://sourcegraph.com/search?q=context:global+file:.nix%24+{searchTerms}&patternType=literal"
  #       "https://github.com/search?q=language%3ANix+{searchTerms}&type=code"
  #       "https://search.nixos.org/packages?&query={searchTerms}"
  #       "https://duckduckgo.com/?q={searchTerms}"
  #       "https://mynixos.com/search?q={searchTerms}"
  #     ];
  #     "VoiceInteractionContextEnabled" = false;
  #     "MediaRouterCastAllowAllIPs" = true;
  #     "TabOrganizerSettings" = 1;
  #     "DevToolsGenAiSettings" = 2; # disable

  #     "ShowCastIconInToolbar" = true;
  #     "CreateThemesSettings" = 2;

  #     "ExtensionSettings" = {
  #       # raindrop
  #       "ldgfbffkinooeloadekpmfoklnobpien" = {
  #         "toolbar_pin" = "force_pinned";
  #       };

  #       # ublock
  #       "cjpalhdlnbpafiamejdnhcphjbkeiagm" = {
  #         "toolbar_pin" = "force_pinned";
  #       };

  #       # keepassxc
  #       "oboonakemofpalcgghocfoadofidjkkk" = {
  #         "toolbar_pin" = "force_pinned";
  #       };

  #       # vimium
  #       "dbepggeogbaibhgnhhndojpepiihcmeb" = {
  #         "toolbar_pin" = "force_pinned";
  #       };

  #       # wallabag
  #       "gbmgphmejlcoihgedabhgjdkcahacjlj" = {
  #         "toolbar_pin" = "force_pinned";
  #       };
  #     };
  #   };
  # };
}
