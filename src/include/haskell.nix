{ config, pkgs, ... } :

{

  nixpkgs.config = {

    packageOverrides = pkgs: {

      haskell_7_6 = (pkgs.haskellPackages_ghc763.ghcWithPackagesOld (self: [
        self.haskellPlatform
        self.cabalInstall
      ]));

      # haskell710 = (pkgs.haskellngPackages.ghcWithPackages (self: [ self.cabal-install ]));

      lts311 = (pkgs.haskell.packages.lts-3_11.override {
        overrides = config.haskellPackageOverrides or (self: super: {});
      }).ghcWithPackages (self: [ self.cabal-install self.stack]);

      haskell710 = (pkgs.haskell.packages.ghc7102.override {
        overrides = config.haskellPackageOverrides or (self: super: {});
      }).ghcWithPackages (self: [ self.cabal-install ]);

      haskell78 = (pkgs.haskell.packages.ghc784.override {
        overrides = config.haskellPackageOverrides or (self: super: {});
      }).ghcWithPackages (self: [ self.cabal-install ]);

      haskell74 = (pkgs.haskell.packages.ghc742.override {
        overrides = config.haskellPackageOverrides or (self: super: {});
      }).ghcWithPackages (self: [ self.cabal-install ]);

    };
  };
}

