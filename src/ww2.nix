# the system.  Help is available in the configuration.nix(5) man page
# or the NixOS manual available on virtual console 8 (Alt+F8).

{ config, pkgs, ... }:

rec {
  require = [
      /etc/nixos/hardware-configuration.nix
      ./include/devenv.nix
      ./include/subpixel.nix
      ./include/haskell.nix
      ./include/bashrc.nix
      ./include/systools.nix
      ./include/fonts.nix
      ./include/user-smironov.nix
      ./include/postfix_relay.nix
      ./include/templatecfg.nix
      ./include/xfce-overrides.nix
      ./include/firefox-with-localization.nix
      ./include/wheel.nix
    ];

  # boot.kernelPackages = pkgs.linuxPackages_3_12 // {
  #   virtualbox = pkgs.linuxPackages_3_12.virtualbox.override {
  #     enableExtensionPack = true;
  #   };
  # };

  boot.blacklistedKernelModules = [
    "fbcon"
    "pcspkr"
    "snd_pcsp"
    ];

  boot.kernelParams = [
    # Use better scheduler for SSD drive
    #"elevator=noop"
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  boot.kernelModules = [
    "fuse"
  ];

  i18n = {
    defaultLocale = "ru_RU.UTF-8";
  };

  time.timeZone = "Europe/Moscow";

  networking = {
    hostName = "ww2";
    networkmanager.enable = true;
    proxy.default = "Mironov_S:${import <passwords/kasper>}@proxy.avp.ru:3128";
  };

  networking.firewall = {
    enable = false;
  };

  services.ntp = {
    enable = true;
    servers = [ "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];
  };

  services.openssh = {
    enable = true;
    ports = [22 2222];
    permitRootLogin = "yes";
    gatewayPorts = "yes";
  };

  services.dbus.packages = [ pkgs.gnome.GConf ];

  services.virtualboxHost.enable = true;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql92;
  };

  services.printing = {
    enable = true;
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      "@weekly root nix-collect-garbage -d >/root/cronout"
    ];
  };

  services.xserver = {
    enable = true;

    startOpenSSHAgent = true;

    videoDrivers = [ "intel" "ati" "vesa" "cirrus" ];

    layout = "us,ru";

    xkbOptions = "grp:alt_space_toggle, ctrl:swapcaps, grp_led:caps";

    desktopManager = {
      xfce.enable = true;
    };

    displayManager = {
      sddm.enable = true;
      #lightdm = {
      #  enable = true;
      #};
    };
  };

  hardware = {
    pulseaudio.enable = true;
  };

  security.pki.certificateFiles = [
    ./certs/kasperskylabsenterpriseca.cer
    ./certs/kasperskylabsmoscowca.cer
    ./certs/kasperskylabspolicyca.cer
    ./certs/kasperskylabsrootca.cer
    ./certs/kasperskylabshqca.cer.pem
  ];

  environment.systemPackages = with pkgs ; [
    # X11 apps
    unclutter
    xorg.xdpyinfo
    xorg.xinput
    rxvt_unicode
    vimHugeX
    glxinfo
    feh
    xcompmgr
    zathura
    evince
    xneur
    mplayer
    xlibs.xev
    xfontsel
    xlsfonts
    djvulibre
    wine
    vlc
    libreoffice
    pidgin
    skype
    pavucontrol
    networkmanagerapplet
    cups
    (devenv {
      name = "dev";
      extraPkgs = [ haskell710 ]
        ++ lib.optionals services.xserver.enable devlibs_x11;
    })
    (devenv {
      name = "dev-h78";
      extraPkgs = [ haskell78 ]
        ++ lib.optionals services.xserver.enable devlibs_x11;
    })
    (devenv {
      name = "dev-h74";
      extraPkgs = [ haskell74 ]
        ++ lib.optionals services.xserver.enable devlibs_x11;
    })
    mercurial
    unetbootin
    manpages
    socat
    dmidecode
    xscreensaver
    wireshark
    tig
    pv
    mlton
    minicom
    lsof
    i7z
    hdparm
    ruby
    pv
    figlet
    bvi
  ];

  nixpkgs.config = {
    virtualbox.enableExtensionPack = true;
    allowBroken = true;
    allowUnfree = true;
  };

}

