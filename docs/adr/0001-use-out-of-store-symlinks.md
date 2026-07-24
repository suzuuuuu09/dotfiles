# dotfilesをout-of-store symlinkで配布する

Home Managerは設定ファイルをNix storeへコピーせず、`~/dotfiles`から利用先へout-of-store symlinkを作る。
リポジトリを設定の正本として編集内容をすぐに反映し、環境構築の初期段階から同じ場所を参照できるようにするため、通常のghq管理から外して短く安定した`~/dotfiles`へ置く。
この判断により、任意のcheckout先からの適用と、Nix store内に閉じた配布は行わない。
