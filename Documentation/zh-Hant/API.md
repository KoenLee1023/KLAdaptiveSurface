# API 參考

## `KLAdaptiveSurface.normalize(_:using:)`

根據`Configuration`整理一個`CGColor`。這個操作是同步的，不會保存或持有圖片資料。

## `KLAdaptiveSurface.Configuration`

定義是否啟用整理，以及明度、飽和度、髒色閾值、整理強度、色彩偏好和前景色策略。所有數值都會限制在`0...1`範圍內。

## `KLAdaptiveSurface.Result`

包含整理後的`background`、建議使用的`foreground`、`usesDarkForeground`和`wasNormalized`。

## 整理取色結果

取色時應分析實際顯示的圖片區域，而不是整張來源圖片，然後呼叫`KLAdaptiveSurface.normalize(_:using:)`。這個方法不會載入圖片，也不會保存狀態。關閉`Configuration.isEnabled`或遇到無法轉換的色彩時，會回傳原始色彩。

```swift
let result = KLAdaptiveSurface.normalize(sampledColor, using: .reading)
view.backgroundColor = result.background
view.tintColor = result.foreground
```

`wasNormalized`用於判斷背景是否真的被修改。宿主可以據此決定是否保留快取色彩，或在介面中顯示整理狀態。

## Configuration的含義

`brightnessFloor`是明度下限，`saturationCeiling`限制控制項背景的色度。`dirtinessThreshold`決定取樣色彩偏離乾淨背景到什麼程度才開始整理。`normalizationStrength`控制原始色彩與整理結果之間的混合程度。

`colorPreference`決定保留、中和、偏冷或偏暖的色彩傾向。`foregroundStrategy`決定自動對比度，或明確使用深色、淺色前景。這些策略不會依裝置晝夜模式強制切換，淺色背景在深色系統下仍會依對比度使用深色文字。

## 效能與更新責任

這個操作是同步的，也不會持有圖片資料。宿主應使用圖片區域和設定的相同識別來快取`Result`。軟體包不會自行快取結果、監聽系統外觀，也不會替宿主決定何時更新。
