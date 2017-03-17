{ config, pkgs, ... } :
{

  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    shellAliases = {
      l  = "ls -FGh";
      ll  = "ls -al";
      ls   = "ls -1";

      d   = "df -bhl";
      df  = "df -h";

      d1  = "du -d1h";

      v   = "vi";
    };
  };

}
