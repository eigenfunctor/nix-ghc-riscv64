self: super:
  let
    ghcVersion = "ghc8107";
    targetCC = super.pkgsBuildTarget.targetPackages.stdenv.cc;
    notGoldFlag = flag: (builtins.match ".*gold.*" flag) == null;
  in {
    haskell = (super.haskell // {
      packages = (super.haskell.packages // {
        ${ghcVersion} = (super.haskell.packages.${ghcVersion}.override {
          ghc =
            let
              ghcLLVM11 = super.buildPackages.haskell.compiler.${ghcVersion}
                .override({
                  buildLlvmPackages = super.buildPackages.llvmPackages_11;
                  llvmPackages = super.llvmPackages_11;
                });
              ghcWithAtomicFix = ghcLLVM11.overrideAttrs(old: {
                patches = [../patches/riscv64-ghc-atomic-fix.patch] ++ (old.patches or []);
                preConfigure = ''
                  ${old.preConfigure}
                  export LD="${targetCC.bintools}/bin/${targetCC.bintools.targetPrefix}ld"
                  NIX_LDFLAGS+=" -latomic"
                '';
                configureFlags = builtins.filter notGoldFlag (old.configureFlags or []);
              });
            in ghcWithAtomicFix;
        });
      });
    });
  }
