{ stdenv, fetchFromGitHub, pkgconfig }:

stdenv.mkDerivation rec {
  name = "taiga-back-${version}";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "taigaio";
    repo = "taiga-back";
    rev = $version;
    sha256 = "13kdh69lzz81076wp7vddaxwq08vkl6abjp63pa7szdh5bgrqsr3";
  };

  meta = {
    description = "Project management web application with scrum in mind! Built on top of Django and AngularJS (Backend Code)";
    inherit (src.meta) homepage;
    license = stdenv.lib.licenses.agpl3;;
    maintainers = [];
  }
}
