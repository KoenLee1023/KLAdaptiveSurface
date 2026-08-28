# API リファレンス

## `KLAdaptiveSurface.normalize(_:using:)`

`Configuration`に従って一つの`CGColor`を整えます。同期的に実行され、画像データを保存したり保持したりしません。

## `KLAdaptiveSurface.Configuration`

整形の有効・無効、明るさ、彩度、濁りの判定閾値、整える強さ、色の好み、前景色の方針を定義します。数値は`0...1`に収められます。

## `KLAdaptiveSurface.Result`

整えた`background`、推奨する`foreground`、`usesDarkForeground`、`wasNormalized`を保持します。

## サンプリングした色を整える

元画像全体ではなく実際に表示する画像領域を分析してから`KLAdaptiveSurface.normalize(_:using:)`を呼びます。このメソッドは画像を読み込まず、状態も保持しません。`Configuration.isEnabled`が`false`の場合や変換できない色の場合は元の色を返します。

```swift
let result = KLAdaptiveSurface.normalize(sampledColor, using: .reading)
view.backgroundColor = result.background
view.tintColor = result.foreground
```

`wasNormalized`で背景が変更されたか確認できます。キャッシュした色を使い続けるか、整理状態を表示するかをホスト側で判断できます。

## Configurationの意味

`brightnessFloor`は明るさの下限、`saturationCeiling`はコントロール背景の色の強さを制限します。`dirtinessThreshold`は、サンプリングした色がクリーンな背景からどれだけ離れたら整理を開始するかを決めます。`normalizationStrength`は元の色と整理後の色の混合量です。

`colorPreference`で色相を保持するか、中和するか、寒色または暖色に寄せるかを選びます。`foregroundStrategy`は自動コントラスト、明色、暗色の前景を選びます。端末の昼夜モードとは独立しているため、明るい背景にはダークシステム設定でも暗い文字を返せます。

## パフォーマンスと更新責任

処理は同期的で、画像データを保持しません。画像領域と設定の識別子を使って`Result`をホスト側でキャッシュしてください。パッケージ自身はキャッシュや外観監視を行わず、更新のタイミングも決めません。
