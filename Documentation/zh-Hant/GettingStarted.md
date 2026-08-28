# 開始使用

建立設定，整理一個取樣得到的`CGColor`，再把回傳的顏色交給宿主視圖。

```swift
import KLAdaptiveSurface

let result = KLAdaptiveSurface.normalize(sampledColor)
let background = result.background
let foreground = result.foreground
```

如果宿主需要不同的明度下限、飽和度上限、整理強度或前景色策略，可以傳入自訂的`Configuration`。
