{
  stdenv,
  fetchurl,
  os161-binutils,
  gmp,
  libmpc,
  mpfr,
  cloog_0_18_0,
}:
stdenv.mkDerivation rec {
  pname = "os161-gcc";
  version = "4.8.3+os161-2.1";
  src = fetchurl {
    url = "http://www.os161.org/download/gcc-${version}.tar.gz";
    hash = "sha256-BwZZ0Uq2+QXp34mJG3j54FLBFODE0BHGMLLwd4jQNZ4=";
  };

  nativeBuildInputs = [ os161-binutils ];
  buildInputs = [
    gmp
    libmpc
    mpfr
    cloog_0_18_0
  ];
  patches = [ ./gcc.patch ];

  # Compilation fails with C++11 or higher so cap it at 98.
  CXXFLAGS = "-std=c++98";

  # It seems like OS/161's configure scripts are modified to add
  # mips-harvard-os161 as a valid target.
  dontUpdateAutotoolsGnuConfigScripts = true;
  hardeningDisable = [ "format" ];
  preConfigure = ''
    # Perform the build in a different directory (copied from nixpkgs gcc).
    mkdir ../build
    cd ../build
    configureScript=../$sourceRoot/configure
  '';
  configureFlags = [
    "--enable-languages=c,lto"
    "--nfp"
    "--disable-shared"
    "--disable-threads"
    "--disable-libmudflap"
    "--disable-libssp"
    "--disable-libstdcxx"
    "--disable-nls"
    "--target=mips-harvard-os161"
  ];
  postInstall = ''
    cd $out/bin
    for i in mips-*; do ln -s $i os161-`echo $i | cut -d- -f4-`; done
    # Delete the (partially) broken man and info pages.
    rm -rf $out/share/{man,info}
  '';
}
