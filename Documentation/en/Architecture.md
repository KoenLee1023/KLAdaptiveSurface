# Architecture

The package has one public operation and a small value-type policy surface. The input color is converted to sRGB, measured once, normalized when it crosses the configured thresholds, and converted back to a `CGColor`.

The integrating app remains responsible for sampling pixels, deciding when to recompute, caching results, and applying the colors to SwiftUI or UIKit.
