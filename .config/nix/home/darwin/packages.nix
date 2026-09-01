# MacOSでのみ使うパッケージを指定する
{pkgs, ...}: {
  home.packages = [
    pkgs.pngpaste
  ];
}
