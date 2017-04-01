{ config, pkgs, ... } :
{

  users.extraUsers.betaboon = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = ["wheel" "audio"];

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCyNxN6NlWicfTpx4b8S0Cg+PjVCKoUxmQ3Pu4xzT6pLzbe54/uPErIyrORw3x/M6e66FKokHiw4dky1e5OjdoFHPBB/IgB2TiAQCD3xYfIGUHZcefg/toMGIei4eJ3wNe9bKFDkm22DISvme3ZIR7WclCfosrpF32lYURpPu5WRt4XEFlafJ5ihFVaXaLe4TMGN+YeZZqmuM6GP6T9T3mjN0jTEGHuafwUkH2StDI1+6i/G4YB2ZeP1ETvFfXtcHgKkjPzJh8apJp3rHhU4RMEJqq3c5d9zS795Axl0ZfzBTcxWg4mvzDaL0m/aoVGe4erkFFRyhsckL/AtLstZwf5IkaXPSobt/PoMkc55Tmy1+2YeTegQgWZB3e2pYvmWiSvaAcG8DReWCDsMS5CvO4me1SiL7ZJc8cEnoMJoCpI7Qk/tfw3SVC1qIabpaDvWggZyYEASSw+kb+b5bQRl6NeiZWlVedbMxfqDYJXY75b0kSc2yAV6njfy/WtGd2luf7htGMSRVmx0NQaRAZet3dkmM7dZ3BSYp4zgY4vmHZFIGzoBbtAa9GmQe/EnZt6WtEn57OZXiM91z7DZag5g9tI9g0AYnqIoybSftm2v+CJapm6Er2jTjp3aWNQm4mhRPebylxrt7c/V7fTuLS/xaFIChWnsv1AUhdT1HfvBLgjeQ== betaboon@monarch"
    ];

    shell = pkgs.zsh;
    home = "/home/betaboon";
  };

}
