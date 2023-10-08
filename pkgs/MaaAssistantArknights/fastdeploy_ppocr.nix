# imitate https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=maa-assistant-arknights

{ stdenv
, pkgs
, lib
, fetchFromGitHub
, cmake
, opencv
, onnxruntime
, eigen
}:

stdenv.mkDerivation rec {

  pname = "fastdeploy_ppocr";
  version = "20231009-unstable";

  src = fetchFromGitHub {
    owner = "MaaAssistantArknights";
    repo = "FastDeploy";
    rev = "2279e19c150c4fc371a9be291f16f3d52633703d";
    sha256 = "sha256-Uu5uLnJaVEM17xcZbFfrN12JLD4dO91H/dbGqSOymBI=";
  };

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

}
