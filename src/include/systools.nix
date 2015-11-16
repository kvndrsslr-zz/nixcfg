{ config, pkgs, ... } :
{

  environment.systemPackages = with pkgs ; [
    psmisc
    wmctrl
    iptables
    tcpdump
    pmutils
    file
    cpufrequtils
    zip
    unzip
    unrar
    p7zip
    openssl
    cacert
    w3m
    wget
    screen
    fuse
    mpg321
    catdoc
    tftp_hpa
    atool
    ppp
    pptp
    dos2unix
    fuse_exfat
    acpid
    upower
    smartmontools
    tig
    figlet
    manpages
    hdparm
    tree
    curlFull
    usbutils
    sox
    stunnel
    swaks
    usbutils

    mc
    htop
    gitAndTools.gitFull
    ctags
    subversion
  ];

}
