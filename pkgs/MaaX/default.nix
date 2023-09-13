# imitate https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=maa-assistant-arknights

{ maintainers
, stdenv
, lib
, fetchzip
, electron
, android-tools
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, }:

let

in stdenv.mkDerivation rec {

  pname = "MaaX";
  version = "2.0.0-beta.14";

  src = fetchzip {
    url = "https://github.com/MaaAssistantArknights/MaaX/releases/download/v2.0.0-beta.14/maa-x-linux-x64-2.0.0-beta.14.zip";
    sha256 = "sha256-FU/1CPxgi8GK1oZna+LZMc3J04Wn7Fph0c7CIqx1tIE=";
  };

  nativeBuildInputs = [
      makeWrapper
      copyDesktopItems
    ];

  buildInputs = [
     android-tools
     electron
   ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/${pname}
    cp -r -v resources/app/* $out/share/${pname}/
    makeWrapper ${electron}/bin/electron $out/bin/MaaX \
      --argv0 "MaaX" \
      --add-flags "$out/share/${pname}/dist/main/index.cjs" \
      --set LD_LIBRARY_PATH "$LD_LIBRARY_PATH:${stdenv.cc.cc.lib}/lib/"

    mkdir -p $out/share/icons
    ln -s $out/share/${pname}/dist/renderer/assets/icon.png $out/share/icons/MaaX.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = pname;
      exec = "MaaX";
      icon = "MaaX";
      categories = [ "Game" "StrategyGame" ];
      comment = meta.description;
    })
  ];


  meta = with lib; {
    description = "MaaAssistantArknights GUI with Electron & Vue3";
    homepage = "MaaAssistantArknights";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Cryolitia ];
  };
  
}