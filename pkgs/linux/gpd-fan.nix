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
    rev = "425e370eb17a6410daea2ad0f5f6037ef1440137";
    hash = "sha256-NTb5cU0TpLJqX7P3rraaiD80H7NcCZqIIrT1mhFJ4/U=";
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
