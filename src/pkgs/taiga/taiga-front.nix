{ stdenv, fetchFromGitHub, pkgconfig }:

stdenv.mkDerivation rec {
  name = "taiga-front-${version}";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "taigaio";
    repo = "taiga-front";
    rev = $version;
    sha256 = "0m90d1b76pkwjrp6rk0x51ja40s95gbfcjbwlhwz9h8bfkaj9nq5";
  };

  meta = {
    description = "Project management web application with scrum in mind! Built on top of Django and AngularJS (Front)";
    inherit (src.meta) homepage;
    license = stdenv.lib.licenses.agpl3;;
    maintainers = [];
  }
}
