self: super:
  let
    ghcVersion = "ghc8104";
  in {
    haskell = (super.haskell // {
      packages = (super.haskell.packages // {
        ${ghcVersion} = (super.haskell.packages.${ghcVersion}.override {
          ghc = (super.buildPackages.callPackage ../pkgs/ghc8104.nix {
            disableLdGold = true;
            bootPkgs = super.buildPackages.haskell.packages.ghc865Binary;
            inherit (super.python3Packages) sphinx;
            buildLlvmPackages = super.buildPackages.llvmPackages_11;
            llvmPackages = super.llvmPackages_11;
          });
        });
      });
    });
  }
