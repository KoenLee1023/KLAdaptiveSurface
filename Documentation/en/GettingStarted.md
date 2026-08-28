# Getting Started

Create a configuration, normalize a sampled `CGColor`, and apply the returned colors to the host surface and its content.

```swift
import KLAdaptiveSurface

let result = KLAdaptiveSurface.normalize(sampledColor)
let background = result.background
let foreground = result.foreground
```

Use `Configuration` when the host needs a different brightness floor, saturation ceiling, normalization strength, or foreground policy.
