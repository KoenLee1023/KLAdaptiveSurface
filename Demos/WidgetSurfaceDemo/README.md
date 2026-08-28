# Widget Surface Demo

> Package documentation: [English](../../README.md) · [简体中文](../../Documentation/zh-Hans/README.md) · [繁體中文](../../Documentation/zh-Hant/README.md) · [日本語](../../Documentation/ja/README.md) · [한국어](../../Documentation/ko/README.md)

This demo applies a separate policy to compact cards while keeping the same
normalization engine as the reading surface.

Source package: [KLAdaptiveSurface](https://github.com/KoenLee1023/KLAdaptiveSurface)

```swift
let policy = KLAdaptiveSurface.Configuration(
    isEnabled: settings.isSurfaceNormalizationEnabled,
    brightnessFloor: settings.brightnessFloor,
    saturationCeiling: settings.saturationCeiling,
    dirtinessThreshold: settings.dirtinessThreshold,
    normalizationStrength: settings.normalizationStrength,
    colorPreference: settings.colorPreference,
    foregroundStrategy: .automatic
)
let surface = KLAdaptiveSurface.normalize(sampledColor, using: policy)
```

The widget can persist these settings in its shared container and pass the
same policy to every card size.
