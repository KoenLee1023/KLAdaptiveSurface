# 开始使用

创建配置，整理一个采样得到的`CGColor`，再把返回的颜色交给宿主视图。

```swift
import KLAdaptiveSurface

let result = KLAdaptiveSurface.normalize(sampledColor)
let background = result.background
let foreground = result.foreground
```

如果宿主需要不同的明度下限、饱和度上限、整理强度或前景色策略，可以传入自定义的`Configuration`。
