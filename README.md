# KLAdaptiveSurface

> Languages: [English](README.md) · [简体中文](Documentation/zh-Hans/README.md) · [繁體中文](Documentation/zh-Hant/README.md) · [日本語](Documentation/ja/README.md) · [한국어](Documentation/ko/README.md)

`KLAdaptiveSurface` turns a sampled image color into a readable surface without applying a fixed light or dark overlay. The policy can leave an already clean color untouched, normalize only colors that cross a configured threshold, and choose a foreground using the resulting background rather than the device appearance.

The package is deliberately independent from wondays. It accepts a `CGColor`,
applies a configurable policy in one pass, and returns the background,
foreground, contrast direction, and whether normalization was needed.

## Usage

```swift
import KLAdaptiveSurface

let configuration = KLAdaptiveSurface.Configuration(
    isEnabled: true,
    brightnessFloor: 0.90,
    saturationCeiling: 0.12,
    dirtinessThreshold: 0.01,
    normalizationStrength: 0.88,
    colorPreference: .preserveHue,
    foregroundStrategy: .automatic
)

let surface = KLAdaptiveSurface.normalize(sampledColor, using: configuration)

view.backgroundColor = UIColor(cgColor: surface.background)
view.tintColor = UIColor(cgColor: surface.foreground)
```

`brightnessFloor` and `saturationCeiling` define the configured range.
`dirtinessThreshold` lets clean colors pass through without adding a gray cast.
`normalizationStrength` controls how far an out-of-range color moves toward the
range. `colorPreference` can preserve the source hue, reduce it toward neutral,
or apply a restrained cool or warm bias. `foregroundStrategy` selects the
foreground policy.

## Public API

`KLAdaptiveSurface.Configuration` is mutable and can be stored with a host theme or per-surface preference. `isEnabled` bypasses normalization when the feature is disabled. `reading` is the built-in configuration for text-heavy surfaces.

`KLAdaptiveSurface.normalize(_:using:)` returns `KLAdaptiveSurface.Result`. The result contains the final `background`, the selected `foreground`, `usesDarkForeground`, and `wasNormalized`. The package accepts and returns `CGColor`, so it does not impose a SwiftUI or UIKit dependency.

The normalization policy is deterministic for the same color and configuration. It does not sample images, blur edges, infer a scene, or decide whether an image should be used. A host such as a widget or a detail view can perform image analysis separately and pass the chosen color here.

## Installation

```swift
dependencies: [
    .package(
        url: "https://github.com/KoenLee1023/KLAdaptiveSurface.git",
        from: "0.1.0"
    )
]
```

## Demos

- [Reading surface demo](Demos/ReadingSurfaceDemo/README.md)
- [Widget surface demo](Demos/WidgetSurfaceDemo/README.md)

## Requirements

- iOS 17 or later
- macOS 14 or later
- Swift 6.0 or later
- MIT License

## Demos

- [Reading surface demo](Demos/ReadingSurfaceDemo/README.md)
- [Widget surface demo](Demos/WidgetSurfaceDemo/README.md)

The source repository is [KoenLee1023/KLAdaptiveSurface](https://github.com/KoenLee1023/KLAdaptiveSurface).
