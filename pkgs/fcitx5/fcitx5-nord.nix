{ maintainers
, stdenvNoCC
, lib
, fetchFromGitHub
}:
stdenvNoCC.mkDerivation rec {

  pname = "fcitx5-nord";
  version = "unstable-20210727";

  src = fetchFromGitHub {
    owner = "tonyfettes";
    repo = "fcitx5-nord";
    rev = "bdaa8fb723b8d0b22f237c9a60195c5f9c9d74d1";
    sha256 = "sha256-qVo/0ivZ5gfUP17G29CAW0MrRFUO0KN1ADl1I/rvchE=";
  };

  installPhase = ''
    install -dDm644 Nord* $out/share/fcitx5/themes/
  '';

  meta = with lib; {
    description = "Fcitx5 theme based on Nord color.";
    homepage = "https://github.com/tonyfettes/fcitx5-nord";
    license = licenses.mit;
    maintainers = with maintainers; [ Cryolitia ];
  };
}