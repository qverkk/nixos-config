{ pkgs, ... }:
{
  home.packages = with pkgs; [ lazygit ];

  # trace: warning: The option `programs.git.extraConfig'  has been renamed to `programs.git.settings'.

  programs.delta = {
    enable = true;
    options = {
      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-decoration-style = "none";
        file-style = "bold yellow ul";
      };
      features = "decorations";
      whitespace-error-style = "22 reverse";
    };
  };

  programs.git = {
    enable = true;

    settings = {
      credential.helper = "keepassxc --git-groups";
      user = {
        email = "membersy@gmail.com";
        name = "qverkk";
      };
      alias = {
        a = "add";
        b = "branch";
        c = "commit";
        ca = "commit --amend";
        cm = "commit -m";
        co = "checkout";
        d = "diff";
        ds = "diff --staged";
        p = "push";
        pf = "push --force-with-lease";
        pl = "pull";
        l = "log";
        r = "rebase";
        s = "status --short";
        ss = "status";
        forgor = "commit --amend --no-edit";
        graph = "log --all --decorate --graph --oneline";
        oops = "checkout --";
      };

    };

    ignores = [
      "*~"
      "*.swp"
      "*result*"
      ".direnv"
      "node_modules"
    ];
  };
}
