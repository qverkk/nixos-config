{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ brave ];

  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "oboonakemofpalcgghocfoadofidjkkk" # keepassxc
      "ldgfbffkinooeloadekpmfoklnobpien" # raindrop
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
      "mdjildafknihdffpkfmmpnpoiajfjnjd" # consent o matic
      "lckanjgmijmafbedllaakclkaicjfmnk" # clear urls
      "ldpochfccmkkmhdbclfhpagapcfdljkj" # decentraleyes
      "gbmgphmejlcoihgedabhgjdkcahacjlj" # wallabag
    ];
    extraOpts = {
      "BrowserSignin" = 0;
      "BookmarkBarEnabled" = false;
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "PasswordSharingEnabled" = false;
      "SpellcheckEnabled" = true;
      "SpellcheckLanguage" = [
        "pl"
        "en-US"
      ];
      "ClearBrowsingDataOnExitList" = [ "password_signin" ];
      "RestoreOnStartup" = 1;
      "ShowHomeButton" = false;
      "BrowserLabsEnabled" = false;
      "AdsSettingForIntrusiveAdsSites" = 2;
      "GoogleSearchSidePanelEnabled" = false;
      "SearchSuggestEnabled" = false;
      "DefaultSearchProviderEnabled" = true;
      "DefaultSearchProviderAlternateURLs" = [
        "https://search.brave.com/search?q={searchTerms}"
        "https://sourcegraph.com/search?q=context:global+file:.nix%24+{searchTerms}&patternType=literal"
        "https://github.com/search?q=language%3ANix+{searchTerms}&type=code"
        "https://search.nixos.org/packages?&query={searchTerms}"
        "https://duckduckgo.com/?q={searchTerms}"
        "https://mynixos.com/search?q={searchTerms}"
      ];
      "VoiceInteractionContextEnabled" = false;
      "MediaRouterCastAllowAllIPs" = true;
      "TabOrganizerSettings" = 1;
      "DevToolsGenAiSettings" = 2; # disable

      "ShowCastIconInToolbar" = true;
      "CreateThemesSettings" = 2;

      "ExtensionSettings" = {
        # raindrop
        "ldgfbffkinooeloadekpmfoklnobpien" = {
          "toolbar_pin" = "force_pinned";
        };

        # ublock
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" = {
          "toolbar_pin" = "force_pinned";
        };

        # keepassxc
        "oboonakemofpalcgghocfoadofidjkkk" = {
          "toolbar_pin" = "force_pinned";
        };

        # vimium
        "dbepggeogbaibhgnhhndojpepiihcmeb" = {
          "toolbar_pin" = "force_pinned";
        };

        # wallabag
        "gbmgphmejlcoihgedabhgjdkcahacjlj" = {
          "toolbar_pin" = "force_pinned";
        };
      };
    };
  };
}
