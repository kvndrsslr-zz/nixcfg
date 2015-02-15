{ config, pkgs, ... } :

{

  nixpkgs.config = {

    packageOverrides = pkgs: {

      haskell_7_6 = (pkgs.haskellPackages_ghc763.ghcWithPackagesOld (self: [
        self.haskellPlatform
        self.cabalInstall
      ]));

      haskell_7_8 = (pkgs.haskellPackages_ghc784.ghcWithPackagesOld (self: [
        # self.haskellPlatform
        self.cabalInstall
      ]));

    };
  };
}

