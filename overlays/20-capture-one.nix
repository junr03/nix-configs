self: super:
with super; {
  capture-one = stdenvNoCC.mkDerivation rec {
    pname = "capture-one";
    version = "16.6.5.17";

    src = fetchurl {
      url = "https://downloads.captureone.pro/d/mac/39c0c6f987ddd1d187d6fb3cb3680b01673344cc/CaptureOne.Mac.16.6.5.17.dmg";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # TODO: replace with actual hash
    };

    nativeBuildInputs = [ undmg ];

    unpackPhase = ''
      undmg "$src"
    '';

    installPhase = ''
      APP_NAME="Capture One.app"
      echo "Installing $APP_NAME into /Applications"
      mkdir -p /Applications
      cp -R "$APP_NAME" /Applications/
      rm -rf "$APP_NAME"
      mkdir -p $out
    '';

    meta = with lib; {
      description = "Capture One photo editing software";
      homepage = "https://www.captureone.com/";
      license = licenses.unfree;
      platforms = platforms.darwin;
    };
  };
}
