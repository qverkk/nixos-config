self: super: {
  leetcode-cli = super.leetcode-cli.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        # ./patches/directory-slug.patch
      ];
  });
}
