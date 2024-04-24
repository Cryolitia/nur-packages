{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, kernel
}:

stdenv.mkDerivation (finalAttr: {
  pname = "gpd-fan-driver";
  version = "0-unstable";

  src = fetchFromGitHub {
    owner = "Cryolitia";
    repo = finalAttr.pname;
    rev = "4523cfc8abb855ce96a407af2f71dab6487e905e";
    hash = "sha256-P29nGGZ4OBkFwFErh9CEZJ2fXoqnmf6Do5G1UvB73w4=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall

    install *.ko -Dm444 -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpdfan

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/Cryolitia/gpd-fan-driver/";
    description = "A kernel driver for the GPD devices fan";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ Cryolitia ];
    platforms = [ "x86_64-linux" ];
  };
})
