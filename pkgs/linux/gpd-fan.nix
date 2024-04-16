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
    rev = "21f18bde711ede0491abf42f31a7a064aa5df037";
    hash = "sha256-FCUfT04Dft4clPBInQZ7DqaM77QQH8Nf1NydqV5zx5o=";
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
