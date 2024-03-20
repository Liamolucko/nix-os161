{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  pname = "os161-binutils";
  version = "2.24+os161-2.1";
  src = fetchurl {
    url = "http://www.os161.org/download/binutils-${version}.tar.gz";
    hash = "sha256-fBIhrVOO4tcs5La62ZbXAbKo4hl3wP18m7YCDANc5mQ=";
  };

  # It seems like OS/161's configure scripts are modified to add
  # mips-harvard-os161 as a valid target.
  dontUpdateAutotoolsGnuConfigScripts = true;
  configureFlags = [
    "--nfp"
    "--disable-werror"
    "--target=mips-harvard-os161"
  ];
  postInstall = ''
    cd $out/bin
    for i in mips-*; do ln -s $i os161-`echo $i | cut -d- -f4-`; done
  '';
}
