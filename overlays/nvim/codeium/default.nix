final: prev: {
  codeium-vim = prev.vimPlugins.codeium-vim.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        ./patches/wrap-with-steam-run.patch
      ];
  });
}
