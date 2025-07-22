{ stdenv, lib }:

stdenv.mkDerivation rec {
  pname = "bluecurve-theme";
  version = "1.0";

  dontBuild = true;

  src = ./bluecurve;

  installPhase = ''
    mkdir -p $out/share/themes/
    cp -r themes/* $out/share/themes/

    mkdir -p $out/share/icons/
    cp -r icons/* $out/share/icons/
  '';

  meta = with lib; {
    description = "Bluecurve GTK and icon theme";
    homepage = "https://github.com/nijakow/bluecurve";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
