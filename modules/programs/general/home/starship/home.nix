{lib, ...}: {
  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$package"
        "$python"
        "$java"
        "$rust"
        "$nix_shell"
        "$line_break"
        "$jobs"
        "$character"
      ];
      nix_shell.symbol = "❄️ ";
    };
  };
}
