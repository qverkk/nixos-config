{pkgs, ...}: {
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
      {id = "oboonakemofpalcgghocfoadofidjkkk";} # keepassxc
      {id = "ldgfbffkinooeloadekpmfoklnobpien";} # raindrop
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # vimium
      {id = "mdjildafknihdffpkfmmpnpoiajfjnjd";} # consent o matic
      {id = "lckanjgmijmafbedllaakclkaicjfmnk";} # clear urls
      {id = "ldpochfccmkkmhdbclfhpagapcfdljkj";} # decentraleyes
      {id = "gbmgphmejlcoihgedabhgjdkcahacjlj";} # wallabag
    ];
  };
}
