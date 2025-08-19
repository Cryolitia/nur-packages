{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "mdbook-typst-pdf";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "KaiserY";
    repo = "mdbook-typst-pdf";
    rev = "v${version}";
    hash = "sha256-uHsyQOaqRhIITaWhl0AQwzZWousmOX6Cbg74WpzeZ2M=";
  };

  cargoHash = "sha256-QhXJZ0F1RTkuPW+bebYr7l9V3V8v/T3kcW1VEcgKTqI=";

  meta = with lib; {
    description = "将 mdBook 转换为 PDF。";
    homepage = "https://github.com/KaiserY/mdbook-typst-pdf";
    license = licenses.asl20;
    maintainers = with maintainers; [ Cryolitia ];
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
}
