# Migration

Replace app-local color cleanup with `KLAdaptiveSurface.normalize(_:using:)` at the point where the host already has a sampled color. Keep image loading, palette sampling, view lifecycle, and caching in the app.

Start with `.reading`, then introduce a custom `Configuration` only when the product has a measured need for another threshold or color preference.
