{ config, pkgs, ... } :
{

  programs.zsh = {
    shellAliases = {
      l  = "ls -FGh";
      ll  = "ls -al";
      ls   = "ls -1";

      d   = "df -bhl";
      df  = "df -h";

      d1  = "du -d1h";

      v   = "vi";

      json_pp = "python -m json.tool $1";
    };
  };

}
