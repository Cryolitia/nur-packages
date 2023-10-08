# imitate https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=maa-assistant-arknights

{ maintainers
, stdenv
, pkgs
, lib
, fetchFromGitHub
, cmake
, opencv
, onnxruntime
, zlib
, asio
, libcpr
, python3
, android-tools
, makeWrapper
, range-v3
, maaVersion ? "4.24.0"
, maaSourceHash ? "sha256-I1HKYO+ywLVUKNl1FH66efAUd4je2d1ynnDEelHZfK8="
}:

let

  fastdeploy_ppocr = pkgs.callPackage ./fastdeploy_ppocr.nix { };

  maa-cli = pkgs.callPackage ./maa-cli.nix { inherit maintainers; };

  name = "maaassistantarknights";

  maaCore = stdenv.mkDerivation
    rec {

      pname = "maacore";
      version = maaVersion;

      src = fetchFromGitHub {
        owner = "MaaAssistantArknights";
        repo = "MaaAssistantArknights";
        rev = "v${version}";
        sha256 = maaSourceHash;
      };

      postPatch = ''
        sed -i 's/RUNTIME\sDESTINATION\s\./ /g; s/LIBRARY\sDESTINATION\s\./ /g; s/PUBLIC_HEADER\sDESTINATION\s\./ /g' CMakeLists.txt
        sed -i 's/find_package(asio /# find_package(asio /g' CMakeLists.txt
        sed -i 's/asio::asio/ /g' CMakeLists.txt

        find "src/MaaCore" \
            \( -name '*.h' -or -name '*.cpp' -or -name '*.hpp' -or -name '*.cc' \) \
            -exec sed -i 's/onnxruntime\/core\/session\///g' {} \;
      '';

      nativeBuildInputs = [
        cmake
      ];

      buildInputs = [
        opencv
        onnxruntime
        fastdeploy_ppocr
        zlib
        asio
        libcpr
        python3
      ] ++ lib.optional stdenv.isDarwin [ range-v3 ];

      cmakeFlags = [
        "-DCMAKE_BUILD_TYPE=None"
        "-DUSE_MAADEPS=OFF"
        "-DINSTALL_THIRD_LIBS=ON"
        "-DINSTALL_RESOURCE=ON"
        "-DINSTALL_PYTHON=ON"
        "-DMAA_VERSION=v${version}"
      ];

      postInstall = ''
        mkdir -pv $out/share/${name}
        mv -v $out/Python $out/share/${name}
        mv -v $out/resource $out/share/${name}
      '';
    };

in
stdenv.mkDerivation rec {

  pname = name;
  version = maaVersion;

  nativeBuildInputs = [
    makeWrapper
  ];

  dontUnpack = true;

  buildInputs = [
    maaCore
    maa-cli
    android-tools
  ];

  postInstall = ''
    mkdir -pv $out/share/${name}
    ln -sv ${maaCore}/share/${name}/* $out/share/${name}
    ln -sv ${maaCore}/lib/* $out/share/${name}

    mkdir -pv $out/bin
    cp -v ${maa-cli}/bin/* $out/share/${name}
    makeWrapper $out/share/${name}/maa $out/bin/maa
  '';

  meta = with lib; {
    description = "An Arknights assistant";
    homepage = "https://github.com/MaaAssistantArknights/MaaAssistantArknights";
    license = licenses.agpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ Cryolitia ];
    mainProgram = "maa";
  };

}
