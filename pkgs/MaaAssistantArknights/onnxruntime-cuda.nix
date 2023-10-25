{ stdenv
, gcc11Stdenv
, onnxruntime
, lib
, fetchpatch
, fetchFromGitHub
, cudaPackages
, symlinkJoin
, pythonSupport ? false
}:

# assert stdenv.hostPlatform.system == "x86_64-linux";

let

  _CUDA_ARCHITECTURES="52-real;53-real;60-real;61-real;62-real;70-real;72-real;75-real;80-real;86-real;87-real;89-real;90-real;90-virtual";

  cutlass = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    rev = "v3.0.0";
    sha256 = "sha256-YPD5Sy6SvByjIcGtgeGH80TEKg2BtqJWSg46RvnJChY=";
  };

  cuda = import ../common/cuda.nix { inherit cudaPackages; inherit symlinkJoin; };

in (onnxruntime.override {

  inherit pythonSupport;
  stdenv = gcc11Stdenv;

}).overrideAttrs (oldAttrs: rec {

  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ cuda.cuda-native-redist;

  buildInputs = oldAttrs.buildInputs ++ cuda.cuda-common-redist;

  requiredSystemFeatures = [ "big-parallel" ];

  cmakeFlags = oldAttrs.cmakeFlags ++ [
    "-DCMAKE_CUDA_ARCHITECTURES=${with cudaPackages.cudaFlags; builtins.concatStringsSep ";" (map dropDot cudaCapabilities)}"
    "-DCMAKE_CUDA_STANDARD_REQUIRED=ON"
    "-DCMAKE_CXX_STANDARD_REQUIRED=ON"
    "-Donnxruntime_USE_CUDA=ON"
    "-Donnxruntime_CUDA_HOME=${cuda.cuda-redist}"
    "-Donnxruntime_CUDNN_HOME=${cudaPackages.cudnn}"
    "-DFETCHCONTENT_SOURCE_DIR_CUTLASS=${cutlass}"
    "-Donnxruntime_USE_NCCL=ON"
    "-DBUILD_TESTING=OFF"
    "-Donnxruntime_BUILD_UNIT_TESTS=OFF"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  patches = [
    # https://github.com/microsoft/onnxruntime/pull/17843
    (fetchpatch {
      url = "https://github.com/bverhagen/onnxruntime/commit/50d5eb3ffc19734e3f0009e800c50d626b12da14.patch";
      sha256 = "sha256-Om8qmJPts7Ly3ljBsTaSL1FoyVclh3TzEy5cZ+FTi7w=";
    })
  ];

  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -pv $out
    cp -rv ./* $out
    rm -v $out/lib/libonnxruntime_providers_tensorrt.so

    cp -rv ${src2}/include/* $out/include/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cross-platform, high performance scoring engine for ML models";
    longDescription = ''
      ONNX Runtime is a performance-focused complete scoring engine
      for Open Neural Network Exchange (ONNX) models, with an open
      extensible architecture to continually address the latest developments
      in AI and Deep Learning. ONNX Runtime stays up to date with the ONNX
      standard with complete implementation of all ONNX operators, and
      supports all ONNX releases (1.2+) with both future and backwards
      compatibility.
    '';
    homepage = "https://github.com/microsoft/onnxruntime";
    changelog = "https://github.com/microsoft/onnxruntime/releases/tag/v${version}";
    platforms = [ "x86_64-linux" ];
    broken = stdenv.hostPlatform.system != "x86_64-linux";
    license = licenses.mit;
  };

})
