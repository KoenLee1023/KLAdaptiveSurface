# はじめに

設定を作り、サンプリングした`CGColor`を整えて、返された色をホストビューに適用します。

```swift
import KLAdaptiveSurface

let result = KLAdaptiveSurface.normalize(sampledColor)
let background = result.background
let foreground = result.foreground
```

明るさの下限、彩度の上限、整える強さ、前景色の方針を変える場合は、`Configuration`を指定します。
