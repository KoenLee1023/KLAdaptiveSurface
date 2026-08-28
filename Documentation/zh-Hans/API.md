# API 参考

## `KLAdaptiveSurface.normalize(_:using:)`

根据`Configuration`整理一个`CGColor`。这个操作是同步的，不会保存或持有图片数据。

## `KLAdaptiveSurface.Configuration`

定义是否启用整理，以及明度、饱和度、脏色阈值、整理强度、色彩偏好和前景色策略。所有数值都会限制在`0...1`范围内。

## `KLAdaptiveSurface.Result`

包含整理后的`background`、建议使用的`foreground`、`usesDarkForeground`和`wasNormalized`。

## 整理取色结果

取色时应分析实际显示的图片区域，而不是整张源图，然后调用`KLAdaptiveSurface.normalize(_:using:)`。这个方法不会加载图片，也不会保存状态。关闭`Configuration.isEnabled`或遇到无法转换的颜色时，它会返回原始颜色。

```swift
let result = KLAdaptiveSurface.normalize(sampledColor, using: .reading)
view.backgroundColor = result.background
view.tintColor = result.foreground
```

`wasNormalized`用于判断背景是否真的被修改。宿主可以据此决定是否保留缓存颜色，或在界面中显示整理状态。

## Configuration的含义

`brightnessFloor`是明度下限，`saturationCeiling`限制控件背景的色度。`dirtinessThreshold`决定取样颜色偏离干净背景到什么程度才开始整理。`normalizationStrength`控制原色与整理结果之间的混合程度。

`colorPreference`决定保留、中和、偏冷或偏暖的色彩倾向。`foregroundStrategy`决定自动对比度，或明确使用深色、浅色前景。这些策略不跟随设备昼夜模式强行切换，浅色背景在深色系统下仍会根据对比度使用深色文字。

## 性能与刷新责任

该操作是同步的，且不会持有图片数据。宿主应使用图片区域和配置的相同身份缓存`Result`。软件包不会自行缓存结果、监听系统外观，也不会替宿主决定何时刷新。
