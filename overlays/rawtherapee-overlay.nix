final: prev: {
  rawtherapee =
    (prev.rawtherapee.override {
      stdenv = prev.impureUseNativeOptimizations prev.stdenv;
    }).overrideAttrs
      (old: {
        src = prev.fetchFromGitHub {
          owner = "Beep6581";
          repo = "RawTherapee";
          rev = "5.12";
          hash = "sha256-h8eWnw9I1R0l9WAI/DylsdA241qU9NhYGEPYz+JlE18=";
          # The developers ask not to use the tarball from Github releases, see
          # https://www.rawtherapee.com/downloads/5.10/#news-relevant-to-package-maintainers
          forceFetchGit = true;
        };
      });
}
