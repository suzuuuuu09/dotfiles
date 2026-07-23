#set page(columns: 3)
#set page(paper: "a4", margin: (x: 1.5cm, y: 2cm))
#set text(font: ("Noto Sans CJK JP", "Hiragino Kaku Gothic ProN"), size: 7pt, lang: "ja")
#show strong: set text(fill: blue)
#show math.equation: set text(size: 6.2pt)
#let term(title, body) = {
  block(breakable: false)[#set par(justify: false) └ #text(fill: red, weight: "bold")[#title]]
  if body != none and body != [] { block(above: 0.3em, inset: (left: 1em), body) }
}
#let boxy(title, body) = block(inset: 0.45em, stroke: 0.4pt + gray, radius: 2pt, above: 0.4em, below: 0.4em, breakable: true)[*#title* \ #body]
#let compare(left, right) = grid(columns: (1fr, 1fr), gutter: 0.45em, stroke: 0.3pt + rgb("c8ced6"), inset: 0.35em, left, right)
#align(center)[
  #text(size: 12pt, weight: "bold", fill: rgb("173b73"))[人工知能2 チートシート]
  #linebreak()
  #text(size: 6.3pt, fill: gray)[教科書準拠: 3.6-3.7 / 第4章 / 5.1・5.3（5.2は試験範囲外）]
]

= 3.6 ニューラルネットワークの代表的な構造
== 全体像・テンソル
ニューラルネットワークは主に、*テンソルを受け取り変換する層*、*層どうしの接続*、*活性化関数*から構成される。
#term[テンソル][スカラー（0階）、ベクトル（1階）、行列（2階）を一般化した多次元配列。各軸の長さを並べたものが *shape*。]
- 画像1枚: $X in RR^(C times H times W)$、ミニバッチ: $X in RR^(N times C times H times W)$。
- $N$: バッチ数、$C$: チャンネル、$H,W$: 高さ・幅。
- ベクトル化して全結合層へ入れると位置構造が失われる。畳み込み層は空間構造を保つ。

== 全結合層（Fully Connected）
#boxy[基本式][$h = W^T x + b$]
- 全入力と全出力を接続する線形変換。後段に活性化関数 $f$ を置き $h=f(W^T x + b)$ とする。
- 複数層を重ねたものが *多層パーセプトロン（MLP）*。
- 入力次元 $D_"in"$、出力次元 $D_"out"$ のパラメータ数は $D_"out" D_"in" + D_"out"$。
- 入力サイズが固定され、画像を平坦化すると画素の近傍関係を直接利用できない。

== 畳み込み層（Convolutional Layer）
#term[フィルタ / カーネル][局所領域に同じ重みを滑らせ、入力との内積を取る。実装上は厳密な畳み込みより *相互相関* に相当することが多い。]
#boxy[2次元畳み込み][$Y_(o,i,j)=sum_c sum_u sum_v K_(o,c,u,v) X_(c, i s + u - p, j s + v - p)$]
- $s$: ストライド、$p$: パディング、$K$: カーネル。
- 出力サイズ: $H_"out"=floor((H+2p-k)/s)+1$、幅も同様。
- パラメータ数: $C_"out" C_"in" k_h k_w + C_"out"$（バイアス込み）。入力の縦横サイズには依存しない。
- *重み共有*: どの位置でも同じフィルタを使うため、全結合よりパラメータが少ない。
- *局所受容野*: 近傍の特徴を抽出し、層を重ねるほど実効受容野が広がる。
- *平行移動同変性*: 入力が移動すると特徴マップも対応して移動する。完全な不変性ではない。
- 複数チャネルでは各入力チャネルの畳み込み結果を加算し、出力チャネルごとに別フィルタを持つ。
- 1×1畳み込み: 空間サイズを変えずチャネル間を混合し、次元削減・復元に使う。
- 全結合を畳み込みに置換した *FCN* は可変サイズ入力を扱いやすい。

== プーリング層
#term[最大値プーリング][領域内の最大値を出力。強い反応を残す。]
#term[平均値プーリング][領域内の平均を出力。平滑化して縮小する。]
- 特徴マップをダウンサンプリングし、計算量を減らし、後段の受容野を広げる。
- 小さな位置ずれに頑健になる一方、正確な位置情報を失う。
- Global Average Pooling は各チャネルを空間方向に平均し、1値へまとめる。

== 再帰層（RNN）
#boxy[基本RNN][$h_t=f(W_x x_t+W_h h_(t-1)+b)$]
- 過去の内部状態 $h_(t-1)$ を使って時系列を処理する。時間方向に展開すると同じ重みを繰り返し使うネットワークになる。
- 多対一: 文分類など。多対多: 系列ラベリング・翻訳など。
- 学習は *BPTT*。長い系列では勾配消失・爆発が起きやすい。
- 勾配爆発対策: *gradient clipping*。長期依存対策: LSTM / GRU。
#term[ゲート][0-1の値で情報を通す量を制御する機構。$g dot.o x$ のように要素積で使う。]
=== LSTM
- セル状態 $c_t$ を長期記憶の経路として保ち、入力・忘却・出力ゲートで更新する。
#boxy[LSTMの代表式][
  $i_t=sigma(W_i[x_t,h_(t-1)]+b_i)$ \
  $f_t=sigma(W_f[x_t,h_(t-1)]+b_f)$ \
  $o_t=sigma(W_o[x_t,h_(t-1)]+b_o)$ \
  $tilde(c)_t=tanh(W_c[x_t,h_(t-1)]+b_c)$ \
  $c_t=f_t dot.o c_(t-1)+i_t dot.o tilde(c)_t$ \
  $h_t=o_t dot.o tanh(c_t)$
]
=== GRU
- LSTMより簡潔。更新ゲート $z_t$ とリセットゲート $r_t$ を使い、セル状態を別に持たない。
#boxy[GRUの代表式][
  $z_t=sigma(W_z[x_t,h_(t-1)])$, $r_t=sigma(W_r[x_t,h_(t-1)])$ \
  $tilde(h)_t=tanh(W_h[x_t,r_t dot.o h_(t-1)])$ \
  $h_t=(1-z_t)dot.o h_(t-1)+z_t dot.o tilde(h)_t$
]

== 活性化関数
#term[ReLU][$f(x)=max(0, x)$。正側の勾配が一定で深い学習に向く。負側は0なので *dead ReLU* に注意。]
- 導関数: $x>0$ で1、$x<0$ で0。
- *Leaky ReLU*: $f(x)=max(alpha x, x)$。負側にも小さい傾き。
- *PReLU*: $alpha$ 自体を学習する。
- ReLU系は区分線形。ネットワーク全体も領域ごとに線形写像となる。
#term[sigmoid][$sigma(x)=1/(1+exp(-x))$、値域 $(0,1)$。$sigma'(x)=sigma(x)(1-sigma(x))$。ゲートや二値確率に利用。飽和領域では勾配が小さい。]
#term[tanh][$tanh(x)=2sigma(2x)-1$、値域 $(-1,1)$、原点対称。$tanh'(x)=1-tanh^2(x)$。]
#term[HardTanh][tanhを区分線形で近似し、上下限でクリップする。]
#term[Softmax][$p_i=exp(z_i)/sum_j exp(z_j)$。総和1。数値安定化では最大値を引く。]
- 温度 $T$: $op("softmax")(z/T)$。$T$ 小→鋭い、$T$ 大→平坦。
- *ELU*: 負側を指数関数で滑らかにする。
- *SELU*: 適切な初期化等と組み合わせ自己正規化を狙う。
- *Swish*: $x sigma(x)$。*GELU*: 滑らかなゲートでTransformerでも利用。
- *Maxout*: 複数の線形出力の最大値。表現力は高いがパラメータ増。
- *CReLU*: $[op("ReLU")(x),op("ReLU")(-x)]$ として正負両方の情報を残す。
- *Lifting Layer*: 低次元入力を複数の非線形基底へ持ち上げる。

= 3.7 第3章まとめ
- 学習は損失関数の勾配を誤差逆伝播で求め、最適化法でパラメータを更新する。
- 深いネットワークでは初期化、活性化、勾配消失・爆発、過学習への対策が重要。
- 代表構造: 全結合、CNN、RNN/LSTM/GRU。

= 第4章 ディープラーニングの発展
学習と予測を改善した中心技術は、*正規化層*、*スキップ接続*、*注意機構*。ReLU系は深層化の土台になった。

= 4.1 活性化関数と深層化
- sigmoid/tanhは飽和領域で導関数が小さく、層を重ねると誤差が消えやすい。
- ReLUは正領域で入力値をそのまま通し、導関数も1なので、活性値と誤差を保ちやすい。
- スケールが不適切なら爆発・消失は起こる。正規化、初期化、スキップ接続と併用する。

= 4.2 正規化層
== 正規化の狙い
1. 不要なスケール自由度を減らし、モデル表現を効率化する。
2. 目的関数の形を扱いやすくし、最適化を安定・高速化する。
3. 層ごとの活性値分布を安定させ、飽和や極端な値を避ける。
== Batch Normalization（BN）
#boxy[学習時のBN][
  $mu_B=1/m sum_(i=1)^m h_i$ \
  $sigma_B^2=1/m sum_(i=1)^m (h_i-mu_B)^2$ \
  $hat(h)_i=(h_i-mu_B)/sqrt(sigma_B^2+epsilon)$ \
  $y_i=gamma hat(h)_i+beta$
]
- $gamma,beta$ は学習可能。正規化で失ったスケールとシフトを再導入できる。
- CNNでは各チャネルについて $N,H,W$ 方向の統計量を取る。
- 学習時はミニバッチ統計、推論時は移動平均の統計量を使う。
- 効果: 学習率を上げやすい、初期値への感度低下、ミニバッチ統計のノイズが正則化として働くことがある。
- 欠点: バッチサイズ依存、学習時と推論時の差、小バッチ・可変長系列で不安定、絶対的スケール情報を消す場合がある。
== LN / IN / GN の違い
#compare[[*BatchNorm* \ 各チャネルごとに $N,H,W$。バッチ依存。CNNで一般的。]][[*LayerNorm* \ 各サンプル内の特徴次元。バッチ非依存。RNN・Transformer向け。]]
#compare[[*InstanceNorm* \ 各サンプル・各チャネルの $H,W$。スタイル変換で利用。]][[*GroupNorm* \ チャネルを群に分け、各群の $C,H,W$。小バッチでも安定。]]
== 重みの正規化・標準化
#term[Weight Normalization][$w=g v/||v||$ とし、長さ $g$ と方向 $v$ を分離して最適化する。]
#term[Weight Standardization][出力チャネルごとのフィルタ重みから平均を引き、標準偏差で割る。]
== 白色化（Whitening）
- 平均0・分散1だけでなく、特徴間の相関も除去する。
- 共分散 $Sigma=E D E^T$ のとき、PCA: $z=D^(-1/2) E^T (x-mu)$、ZCA: $z=E D^(-1/2) E^T (x-mu)$。
- ZCAは元の座標系に近い。固有分解は高コストで不安定になり得る。

= 4.3 スキップ接続
== Residual Learning
#boxy[残差ブロック][$h_(i+1)=h_i+f(h_i)$]
- 恒等写像の経路を追加し、層は入力全体でなく *残差* $f(h_i)$ を学ぶ。
- $partial h_(i+1)/partial h_i=I+partial f/partial h_i$。$I$ の経路が情報・勾配を直接伝える。
- 恒等経路が誤差をそのまま伝え、勾配消失や *Gradient Shattered* を緩和して深層化を可能にする。
- 次元が異なる場合は1×1畳み込みなどでショートカット側を射影する。
- $f(h_i)=h_(i+1)-h_i$ なので「足りない差分」を学ぶ。
- 各ブロックが現在の表現を少しずつ修正する逐次的推論と解釈でき、勾配降下法の更新式と似た加算構造を持つ。
== ResNetのブロック
- 基本ブロック: 3×3畳み込みを重ねて残差を作る。
- *Bottleneck*: 1×1でチャネル削減 → 3×3 → 1×1で復元。
- 初期ResNet: $h_(i+1)=op("ReLU")(h_i+f(h_i))$。加算後のReLUが恒等経路を遮る可能性。
- *Pre-activation*: BN/ReLUを重み層の前へ移し、加算後を線形に保つ。
- *Single ReLU*: ブロック中のReLU数を減らし、情報損失を抑える。
#term[スキップ接続の見方][非常に深いネットワークを、多数の短い経路を共有するアンサンブルのように捉えられる。]

= 4.4 注意機構（Attention）
== 役割と記憶
#term[注意機構][入力に応じて「どの情報を、どの強さで読むか」を動的に選ぶ機構。]
- 表現力: 入力に応じて異なる関数・結合を実現。
- 学習効率: 必要な部分へ更新を集中し、干渉・破滅的忘却を抑える。
- 汎化: 関係のある要素を選び、偽の相関を避ける情報ボトルネックを作る。
- 異なる時間スケール: 遠い過去を必要時に直接参照する。
- RNNは過去を固定長状態へ圧縮するが、Attentionは各状態を保持し必要な時点へ直接アクセスできる。
- 活性値・内部状態は短期記憶、重みは長期記憶。*Fast Weights* は一時的に変化する中間的な記憶。
== Query・Key・Value
#boxy[基本Attention][
  $q=W^Q h_"query"$, $k_j=W^K h_j$, $v_j=W^V h_j$ \
  $e_j=q^T k_j$, $alpha_j=op("softmax")(e_j)$ \
  $u=sum_j alpha_j v_j$
]
- Query: 探している情報、Key: 照合用の見出し、Value: 読み出す内容。
- *Soft attention*: 全要素の重み付き和。微分可能。
- *Hard attention*: 要素を離散的に選択。直接微分しにくい。
- Globalは全要素、Localは限定範囲を見る。
- Cross/Mutual attentionは別系列からQとK,Vを作る。
== Self-Attention
- Q,K,Vを同じ系列から作り、系列内の要素間関係を直接計算する。
- 全位置を並列計算でき、長距離依存の経路が短い。
- 位置を区別できないため位置情報を加える。
#boxy[正弦波位置符号][
  $op("PE")(p, 2i)=sin(p/10000^(2i/d_"model"))$ \
  $op("PE")(p, 2i+1)=cos(p/10000^(2i/d_"model"))$
]
== Scaled Dot-Product Attention
#boxy[行列表現][$op("Attention")(Q, K, V)=op("softmax")((Q K^T)/sqrt(d_k))V$]
- $sqrt(d_k)$ で割り、次元増大によるsoftmaxの飽和を抑える。
- maskでpadding位置や未来位置を $-infinity$ 相当にする。
- 計算・メモリ量は系列長 $n$ に対して基本 $O(n^2)$。
== Multi-Head Attention（MHA）
#boxy[MHA][
  $op("head")_i=op("Attention")(Q W_i^Q, K W_i^K, V W_i^V)$ \
  $op("MHA")(Q, K, V)=op("Concat")(op("head")_1, dots, op("head")_h)W^O$
]
- 複数の表現部分空間・関係を並列に学習する。
== Transformer
#term[基本ブロック][Multi-Head Attention + 位置ごとのFFN + 残差接続 + LayerNorm。]
#boxy[Position-wise FFN][$op("FFN")(x)=W_2 op("ReLU")(W_1x+b_1)+b_2$]
- Encoder: 双方向self-attention。
- Decoder: masked self-attention → cross-attention → FFN。
- *Post-LN*: サブ層→残差加算→LN。*Pre-LN*: LN→サブ層→残差加算。
- *RealFormer*: 前層のattention scoreを次層へ残差的に渡す。

= 第4章まとめ
- 正規化: 活性・重みのスケールを整え、最適化を安定させる。
- スキップ接続: 恒等経路で情報と勾配を直接伝える。
- 注意機構: 必要な情報を入力依存で選び、長距離関係を直接扱う。

= 第5章 ディープラーニングを活用したアプリケーション
教科書の試験範囲である5.1と5.3を扱い、5.2は除外する。
= 5.1 画像認識
== CNNでの画像処理
- 入力は $X in RR^(N times C times H times W)$。
- 前段は線・模様、中段は部品、後段は物体全体という階層的特徴を学ぶ。
- 深くなるほど $H,W$ を縮小しチャネル数を増やす。
- 最後にGlobal Average Poolingや全結合、softmaxで分類する。
- *Top-1 error*: 1位予測が不正解。*Top-5 error*: 正解が上位5候補にない割合。
== 主要画像分類モデル
#term[AlexNet（2012）][GPU、ReLU、dropout、data augmentationを組み合わせ、ILSVRCで大幅改善。]
#term[VGGNet][3×3畳み込みを繰り返す単純で深い構成。パラメータ・計算量が大きい。]
#term[GoogLeNet / Inception][1×1・3×3・5×5・poolingを並列に適用してconcat。1×1で計算量を削減。]
#term[ResNet][残差接続により非常に深いネットワークを学習可能にした。]
#term[DenseNet][各層がそれ以前の全特徴マップをconcatして受け取る。特徴再利用に優れる。]
#term[SENet][Global Average Pooling後、チャネル重要度を求め特徴マップを再重み付けする。]
== CNN以外・Transformer系
#term[Vision Transformer（ViT）][画像をpatchへ分割し、線形埋め込み+位置埋め込みをTransformerへ入力。]
#term[MLP-Mixer][token方向とchannel方向を混ぜるMLPを交互に用いる。]
#term[Swin Transformer][局所window attentionとshifted windowで階層構造を作る。]
== セグメンテーション
#term[Semantic Segmentation][各画素へクラスを付与。個体は区別しない。]
#term[Instance Segmentation][同じクラスでも物体ごとに領域を分離。]
#term[Panoptic Segmentation][semanticとinstanceを統合。]
#term[U-Net][Encoderの高解像度特徴をスキップ接続でDecoderへ渡し、輪郭・位置情報を補う。]
== 物体検出・Mask R-CNN
- 物体検出はクラスとbounding box、instance segmentationではさらにmaskを求める。
- *Backbone*: ResNet等で特徴マップ抽出。
- *RPN*: anchorごとに物体らしさとbox補正量を予測し、候補領域を生成。
- *RoIAlign*: 双線形補間で固定サイズ化し、量子化ずれを避ける。
- Headはクラス分類、box回帰、maskを並列予測。
#term[Anchor-free検出][CornerNetは角、CenterNetは中心等のkeypoint heatmapから物体を表す。]
== 高速化・受容野の工夫
#term[Grouped Convolution][チャネルを $g$ 群に分割し、重み数を概ね $1/g$ に削減。ResNeXt等。]
#term[Channel Shuffle][group間でチャネルを並べ替え、群を越えて情報を混ぜる。]
#term[Depthwise Separable Convolution][チャネル別 $k times k$ → 1×1でチャネル混合。MobileNet等。]
#term[Shift][一部チャネルを上下左右へずらし空間情報を混合。]
#term[Address Shift][参照アドレスを変えてshift相当を実現しメモリ転送を減らす。]
#term[Dilated / Atrous Convolution][カーネル間隔を空け、パラメータ数を増やさず受容野を拡大。]
#term[Deformable Convolution][サンプリング位置のoffsetを学習し、受容野を変形する。]

= 5.3 自然言語処理
== 単語表現と事前学習
- Word2Vec / GloVeは単語を埋め込みベクトルにするが、文脈による意味の違いを表しにくい。
- 大規模コーパスで汎用表現を事前学習し、少量の教師ありデータで各タスクへfine-tuningする。
== BERT
#term[BERT（Bidirectional Encoder Representations from Transformers）][Transformer Encoderを用い、前後両方の文脈からtoken表現を得る。]
=== 学習
- *Masked Language Model*: tokenの15%を選び、元tokenを前後文脈から予測する。
- 選択tokenの80%を[MASK]、10%をランダムtoken、10%を元のままとする。
- 文ペア課題も用い、文間関係を学ぶ。
- 生テキストから正解を自動生成でき、手作業ラベルなしで大規模学習可能。
=== Fine-tuning
- 事前学習済みBERTを分類・系列ラベリング・質問応答等へ少量データで調整する。
- 成功要因: Transformer、双方向文脈、大規模コーパス・モデル、知識の転移。
== GPT-2 / GPT-3
#term[自己回帰言語モデル][$P(y)=product_t P(y_t|y_(<t))$。左から右へ次tokenを予測し、生成と相性がよい。]
- GPTはTransformer Decoder型。未来tokenをmaskしたself-attentionを用いる。
- 規模・データ量・計算量の拡大で多様な言語タスク能力が現れる。
- 指示・例・文脈をpromptに含め、重み更新なしでタスクを実行する *in-context learning*。
- *Zero-shot*: 例なし、*One-shot*: 1例、*Few-shot*: 少数例。
#compare[[*BERT* \ 双方向Encoder、MLM、理解・分類・抽出に強い。]][[*GPT* \ 自己回帰Decoder、次token予測、生成に強い。]]

= 第5章（試験範囲）まとめ
- 画像: AlexNet→VGG/Inception→ResNet/DenseNet/SENet→ViT・Mixer・Swin。分類・検出・segmentationへ展開。
- 高速化: group化、shuffle、depthwise+pointwise、shift。受容野: dilated・deformable。
- 言語: BERTは双方向MLMとfine-tuning、GPTは自己回帰生成とin-context learning。

= 最重要比較・試験直前チェック
#boxy[正規化の軸][BN: 同一channelの $N,H,W$ / LN: 1sample内の特徴全体 / IN: 1sample・1channelの $H,W$ / GN: channel group + $H,W$]
#boxy[深層化を支える3点][ReLU系: 勾配を保ちやすい / 正規化: スケールと最適化を安定 / 残差接続: 恒等経路で情報・勾配を直送]
#boxy[Attentionの暗記][類似度 $Q K^T$ → $sqrt(d_k)$ でscale → mask → softmax → $V$ の重み付き和。Selfは同じ系列、Crossは別系列。]
#boxy[BERTとGPT][BERT: 前後文脈・MLM・Encoder・fine-tuning。 \ GPT: 左から右・次token・Decoder・生成/in-context learning。]
