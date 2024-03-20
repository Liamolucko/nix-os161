{
  stdenv,
  fetchurl,
  ncurses,
}:
stdenv.mkDerivation rec {
  pname = "os161-gdb";
  version = "7.8+os161-2.1";
  src = fetchurl {
    url = "http://www.os161.org/download/gdb-${version}.tar.gz";
    hash = "sha256-HBbi2Ds7/lLoEz48On0fCDstAQ/hwQenjt5kObGx/mE=";
  };

  buildInputs = [ ncurses ];
  patches = [ ./gdb.patch ];

  # It seems like OS/161's configure scripts are modified to add
  # mips-harvard-os161 as a valid target.
  dontUpdateAutotoolsGnuConfigScripts = true;
  # By default Nix passes `--disable-static` without passing `--enable-shared`,
  # which causes neither variant of readline to be built and the build to fail.
  dontDisableStatic = true;
  configureFlags = [ "--target=mips-harvard-os161" ];
  postInstall = ''
    cd $out/bin
    for i in mips-*; do ln -s $i os161-`echo $i | cut -d- -f4-`; done
    # Delete the (partially) broken man and info pages.
    rm -rf $out/share/{man,info}
  '';
}
