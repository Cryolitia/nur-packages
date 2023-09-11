# imitate https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=maa-assistant-arknights

{ stdenv
, fetchFromGitHub
, cmake
, opencv
, onnxruntime
, eigen
, zlib
, asio
, libcpr
, }:

let

  maaVersion = "4.23.3";

  fastdeploy = stdenv.mkDerivation rec {

    pname = "fastdeploy";
    version = "1.0.0";

    src = fetchFromGitHub ({
      owner = "MaaAssistantArknights";
      repo = "FastDeploy";
      rev = "070424e06436524d817131d68c411066fa6069a6";
      sha256 = "sha256-+W9StKABaX/3rHGD8jBCTLFw1kPoHFXjcn96wxXCuDY=";
    });

    nativeBuildInputs = [
      cmake
      eigen
    ];

    buildInputs = [
      opencv
      onnxruntime
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=None"
      "-DBUILD_SHARED_LIBS=ON"
    ];
  
  };

in stdenv.mkDerivation rec {

  pname = "MaaAssistantArknights";
  version = maaVersion;

  src = fetchFromGitHub ({
      owner = "MaaAssistantArknights";
      repo = "MaaAssistantArknights";
      rev = "v${version}";
      sha256 = "sha256-A41kk1Xg9c/QZHOhyakcBULzsNTrsfnGYZ0df+MKWfc=";
    });

  postPatch = ''
    sed -i 's/RUNTIME\sDESTINATION\s\./ /g; s/LIBRARY\sDESTINATION\s\./ /g; s/PUBLIC_HEADER\sDESTINATION\s\./ /g' CMakeLists.txt
    sed -i 's/find_package(asio /# find_package(asio /g' CMakeLists.txt
    sed -i 's/asio::asio/ /g' CMakeLists.txt
  '';

  nativeBuildInputs = [
      cmake
    ];

    buildInputs = [
      opencv
      onnxruntime
      fastdeploy
      zlib
      asio
      libcpr
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=None"
      "-DUSE_MAADEPS=OFF"
      "-DINSTALL_THIRD_LIBS=ON"
      "-DINSTALL_RESOURCE=ON"
      "-DINSTALL_PYTHON=ON"
      "-DMAA_VERSION=v${version}"
    ];
  
}