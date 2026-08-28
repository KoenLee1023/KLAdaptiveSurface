# API Reference

## `KLAdaptiveSurface.normalize(_:using:)`

Normalizes one `CGColor` according to a `Configuration`. The operation is synchronous and does not allocate or retain image data.

## `KLAdaptiveSurface.Configuration`

Defines whether normalization is enabled, how far brightness and saturation may move, the dirtiness threshold, the normalization strength, the color preference, and the foreground strategy. Values are clamped to `0...1`.

## `KLAdaptiveSurface.Result`

Contains the normalized `background`, the recommended `foreground`, `usesDarkForeground`, and `wasNormalized`.

## Normalizing a sampled color

Call `KLAdaptiveSurface.normalize(_:using:)` after sampling the visible image region, not the whole source image. The method does not load images or retain state. It returns the original color when `Configuration.isEnabled` is `false` or when the color cannot be represented in the expected color space.

```swift
let result = KLAdaptiveSurface.normalize(sampledColor, using: .reading)
view.backgroundColor = result.background
view.tintColor = result.foreground
```

`wasNormalized` tells the host whether the background changed. Use it when deciding whether to keep a cached color or expose a normalization state in the UI.

## Configuration semantics

`brightnessFloor` is the minimum lightness target, while `saturationCeiling` limits chroma for control surfaces. `dirtinessThreshold` determines how far a sampled color may deviate from a clean surface before normalization starts. `normalizationStrength` blends between the original and normalized result.

`colorPreference` chooses whether hue is preserved, neutralized, cooled, or warmed. `foregroundStrategy` selects automatic contrast or explicitly dark or light text. These policies are independent from device appearance, so a light background can still receive dark text in a dark system appearance.

## Performance and ownership

The operation is synchronous and does not retain image data. Cache the `Result` using the same image-region and configuration identity used for sampling. The package does not cache results, observe traits, or decide when a host should refresh.
