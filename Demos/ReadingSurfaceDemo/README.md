# Reading Surface Demo

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
