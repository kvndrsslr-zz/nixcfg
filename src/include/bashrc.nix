{ config, pkgs, ... } :
let

  myprofile = import ./myprofile.nix {inherit pkgs; };

in

{
  environment = rec {

    extraInit = ''
      source ${myprofile}
    '';
  };


  programs = {

    bash = {

      promptInit = ''
        PROMPT_COLOR="1;31m"
        let $UID && PROMPT_COLOR="1;32m"
        PS1="\n\[\033[$PROMPT_COLOR\][\u@\h \w ]\\$\[\033[0m\] "
      '';

      enableCompletion = true;
    };
  };
}

