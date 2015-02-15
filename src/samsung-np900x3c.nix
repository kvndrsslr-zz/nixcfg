# the system.  Help is available in the configuration.nix(5) man page
# or the NixOS manual available on virtual console 8 (Alt+F8).

{ config, pkgs, ... }:

rec {
  require = [
      /etc/nixos/hardware-configuration.nix
      ./include/devenv.nix
      ./include/subpixel.nix
      ./include/haskell.nix
      ./include/screenrc.nix
      ./include/bashrc.nix
      ./include/systools.nix
      ./include/fonts.nix
      ./include/security.nix
      ./include/postfix_relay.nix
      ./include/templatecfg.nix
      ./include/xfce-overrides.nix
      ./include/firefox-with-localization.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_3_14;

  boot.blacklistedKernelModules = [
    "fbcon"
    ];

  boot.kernelParams = [
    # Use better scheduler for SSD drive
    "elevator=noop"
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

  hardware = {
    opengl.videoDrivers = [ "intel" ];
    enableAllFirmware = true;
    firmware = [ "/root/firmware" ];
    bluetooth.enable = false;
    pulseaudio.enable = true;
  };

  time.timeZone = "Europe/Moscow";

  networking = {
    hostName = "greyblade";

    networkmanager.enable = true;
  };

  fileSystems = [
    { mountPoint = "/";
      device = "/dev/disk/by-label/ROOT";
      options = "defaults,relatime,discard";
    }
    { mountPoint = "/home";
      device = "/dev/disk/by-label/HOME";
      options = "defaults,relatime,discard";
    }
  ];

  powerManagement = {
    enable = true;
  };

  services.ntp = {
    enable = true;
    servers = [ "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];
  };

  services.openssh = {
    enable = true;
    ports = [22 2222];
    permitRootLogin = "yes";
  };

  services.dbus.packages = [ pkgs.gnome.GConf ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql92;
  };

  services.xserver = {
    enable = true;

    startOpenSSHAgent = true;

    layout = "us,ru";

    xkbOptions = "grp:alt_space_toggle, ctrl:swapcaps, grp_led:caps";

    desktopManager = {
      xfce.enable = true;
    };

    displayManager = {
      lightdm = {
        enable = true;
      };
    };

    multitouch.enable = false;

    synaptics = {
      enable = true;
      accelFactor = "0.05";
      maxSpeed = "10";
      twoFingerScroll = true;
      additionalOptions = ''
        MatchProduct "ETPS"
        Option "FingerLow"                 "3"
        Option "FingerHigh"                "5"
        Option "FingerPress"               "30"
        Option "MaxTapTime"                "100"
        Option "MaxDoubleTapTime"          "150"
        Option "FastTaps"                  "0"
        Option "VertTwoFingerScroll"       "1"
        Option "HorizTwoFingerScroll"      "1"
        Option "TrackstickSpeed"           "0"
        Option "LTCornerButton"            "3"
        Option "LBCornerButton"            "2"
        Option "CoastingFriction"          "20"
      '';
    };

    serverFlagsSection = ''
      Option "BlankTime" "0"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
    '';
  };

  services.virtualboxHost.enable = true;

  environment.systemPackages = with pkgs ; [
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
    xfce.xfce4_cpufreq_plugin
    xfce.xfce4_systemload_plugin
    xfce.xfce4_xkb_plugin
    xfce.gigolo
    xfce.xfce4taskmanager
    vlc
    libreoffice
    pidgin
    gimp_2_8
    skype
    networkmanagerapplet
    pavucontrol
    qbittorrent
    rtorrent

    mercurial
    mlton

    haskell_7_8
    (devenv { enableX11 = services.xserver.enable; })
    imagemagick
    smplayer
  ];

  nixpkgs.config = {
    allowUnfree = true;
    chrome = {
      jre = true;
      enableAdobeFlash = true;
    };
  };
}

