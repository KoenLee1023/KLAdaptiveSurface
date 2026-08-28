# KLAdaptiveSurface

Normalize image-derived surface colors without flattening every image into the same fixed color.

`KLAdaptiveSurface` is a synchronous, configurable color policy. It accepts a `CGColor` and returns a background, a readable foreground, and a flag describing whether normalization was applied.

## When to normalize

Call ``KLAdaptiveSurface/normalize(_:using:)`` after the host has sampled the
color that is actually visible behind text or controls. The function measures
the input once, checks the configured thresholds, and returns a
``KLAdaptiveSurface/Result``. A clean color can pass through unchanged, while
an overly dark, saturated, or visibly dirty color moves toward the readable
range without discarding its hue unless the selected preference asks for it.

``KLAdaptiveSurface/Configuration`` is a policy value. Set `brightnessFloor`
for the minimum brightness, `saturationCeiling` for the maximum saturation,
and `dirtinessThreshold` for the minimum deviation that should trigger work.
`normalizationStrength` controls how far a changed color moves toward the
target range. ``KLAdaptiveSurface/ColorPreference`` chooses hue treatment, and
``KLAdaptiveSurface/ForegroundStrategy`` chooses the recommended text color.

The package does not load images, sample pixels, manage view lifecycle, cache
results, or apply colors to SwiftUI or UIKit. The host should recompute only
when the sampled region or policy changes. `wasNormalized` describes whether
the policy changed the background; `usesDarkForeground` describes the returned
foreground choice, not the device appearance mode.

## Topics

### Configuration

- ``KLAdaptiveSurface/Configuration``
- ``KLAdaptiveSurface/ColorPreference``
- ``KLAdaptiveSurface/ForegroundStrategy``

### Normalization

- ``KLAdaptiveSurface/normalize(_:using:)``
- ``KLAdaptiveSurface/Result``
