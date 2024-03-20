{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  pname = "sys161";
  version = "2.0.8";
  src = fetchurl {
    url = "http://www.os161.org/download/sys161-${version}.tar.gz";
    hash = "sha256-WmQgkMUdovDRkrxFINaariYiI6vcv50dcE8hrm/ZGyY=";
  };

  patches = [ ./sys161.patch ];

  configureFlags = [ "mipseb" ];
}
