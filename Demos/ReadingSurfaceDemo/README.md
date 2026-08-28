# Reading Surface Demo

> Package documentation: [English](../../README.md) · [简体中文](../../Documentation/zh-Hans/README.md) · [繁體中文](../../Documentation/zh-Hant/README.md) · [日本語](../../Documentation/ja/README.md) · [한국어](../../Documentation/ko/README.md)

This demo shows how a photo-derived color can become a readable note surface.

Source package: [KLAdaptiveSurface](https://github.com/KoenLee1023/KLAdaptiveSurface)

```swift
let surface = KLAdaptiveSurface.normalize(
    sampledColor,
    using: .init(
        brightnessFloor: 0.90,
        saturationCeiling: 0.12,
        normalizationStrength: 0.88,
        colorPreference: .preserveHue
    )
)
```

Use `surface.background` for the reading surface and
`surface.foreground` for body text.
