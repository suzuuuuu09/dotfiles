# macOSとWSLでHome Manager構成を共有する

macOSとNixOS-WSLは一つのflakeから構築し、CLI、Fish、Neovim、dotfile、Agent Skillsを`home/common`のHome Manager構成として共有する。
OSごとにリポジトリと設定を分ければ条件分岐は減るが、同じユーザー環境の更新と検証が分岐するため採用しない。
OS固有の設定は`home/darwin`、`home/wsl`、`hosts`へ分離し、両環境で同じ振る舞いが必要な設定だけを`home/common`へ置く。
