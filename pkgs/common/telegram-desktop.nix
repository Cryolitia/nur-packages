{ lib
, telegram-desktop
, qtwayland
}:

(telegram-desktop.override {
  qtwayland = qtwayland.overrideAttrs (oldAttrs: rec {
    patches = oldAttrs.patches ++ [
      # https://gitlab.archlinux.org/archlinux/packaging/packages/telegram-desktop/-/issues/1
      ./telegram-01.patch
    ];
  });
}).overrideAttrs (oldAttrs: rec {
  meta = oldAttrs.meta // {
    # error: Package ‘jasper-4.2.2’ in /nix/store/dfwrffdwrrybch69gawdj9qd1rnp7mnk-source/pkgs/by-name/ja/jasper/package.nix:60 is marked as broken, refusing to evaluate
    badPlatforms = [ "aarch64-linux" ];
  };
})
 
 
