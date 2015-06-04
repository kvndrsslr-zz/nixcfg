{ config, pkgs, ... } :

{

  nixpkgs.config = {

    packageOverrides = pkgs: {

      haskell_7_6 = (pkgs.haskellPackages_ghc763.ghcWithPackagesOld (self: [
        self.haskellPlatform
        self.cabalInstall
      ]));

      # haskell710 = (pkgs.haskellngPackages.ghcWithPackages (self: [ self.cabal-install ]));

      haskell710 = (pkgs.haskell.packages.ghc7101.override {
        overrides = config.haskellPackageOverrides or (self: super: {});
      }).ghcWithPackages (self: [ self.cabal-install ]);

      haskell78 = (pkgs.haskell.packages.ghc784.override {
        overrides = config.haskellPackageOverrides or (self: super: {});
      }).ghcWithPackages (self: [ self.cabal-install ]);

    };
  };
}

