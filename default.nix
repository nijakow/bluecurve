{ stdenv, lib }:

stdenv.mkDerivation rec {
  pname = "bluecurve-theme";
  version = "1.0";

  src = ./bluecurve;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/themes/Bluecurve
    cp -r themes/* $out/share/themes/

    mkdir -p $out/share/icons/Bluecurve
    cp -r icons/* $out/share/icons/Bluecurve
  '';

  meta = with lib; {
    description = "Bluecurve GTK and icon theme";
    homepage = "https://github.com/nijakow/bluecurve-theme";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
