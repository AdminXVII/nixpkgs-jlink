{ stdenv, lib, rpmextract, requireFile, libudev }:

with lib;

stdenv.mkDerivation rec {
  name = "jlink-${version}";
  version = "670a";

  src =
    if stdenv.system == "x86_64-linux" then
      requireFile {
        name = "JLink_Linux_V${version}_x86_64.rpm";
        url = "https://www.segger.com/downloads/jlink/JLink_Linux_V${version}_x86_64.rpm";
        sha256 = "676d972d8ddee6955b2bd8a57b0708c345849b9ef38d0b7d1f4ee2514a9df5e7";
      }
    else if stdenv.system == "i686-linux" then
      requireFile {
        name = "JLink_Linux_V${version}_i386.rpm";
        url = "https://www.segger.com/downloads/jlink/JLink_Linux_V${version}_i386.rpm";
        sha256 = "c8e169163980165eecbeac90787d649ea3ea036140e9c6ac613bc339c30445df";
      }
    else
      abort "${name} requires i686-linux or x86_64 Linux";

  buildInputs = [ rpmextract ];
  phases = [ "unpackPhase" "installPhase" "fixupPhase" "distPhase" ];

  RPATH="${stdenv.cc.cc.lib}/lib:${libudev.lib}/lib";
  unpackPhase = "rpmextract $src";
  installPhase = readFile ./install.sh;

  meta = {
    description = "SEGGER J-Links are the most widely used line of debug probes available today";
    longDescription = "TODO:";
    homepage = https://www.segger.com/downloads/jlink;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pjones ];
  };
}
