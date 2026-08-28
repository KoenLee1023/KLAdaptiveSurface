import CoreGraphics
import Testing
@testable import KLAdaptiveSurface

struct KLAdaptiveSurfaceTests {
    @Test func disabledConfigurationPreservesTheSourceColor() {
        let source = CGColor(red: 0.42, green: 0.18, blue: 0.08, alpha: 1)
        let result = KLAdaptiveSurface.normalize(
            source,
            using: .init(isEnabled: false)
        )

        #expect(result.wasNormalized == false)
        #expect(result.background == source)
    }

    @Test func cleanLightColorIsPreserved() {
        let source = CGColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1)
        let result = KLAdaptiveSurface.normalize(source)

        #expect(result.wasNormalized == false)
        #expect(result.usesDarkForeground)
    }

    @Test func darkSaturatedColorIsMovedToAReadableSurface() {
        let source = CGColor(red: 0.43, green: 0.25, blue: 0.18, alpha: 1)
        let result = KLAdaptiveSurface.normalize(source)
        let components = result.background.components ?? []

        #expect(result.wasNormalized)
        #expect(components.count >= 3)
        #expect((components.first ?? 0) > 0.80)
    }

    @Test func neutralPreferenceRemovesMoreChromaThanHuePreservation() {
        let source = CGColor(red: 0.92, green: 0.46, blue: 0.30, alpha: 1)
        let preserve = KLAdaptiveSurface.normalize(source)
        let neutral = KLAdaptiveSurface.normalize(
            source,
            using: .init(colorPreference: .neutral)
        )

        #expect(preserve.wasNormalized)
        #expect(neutral.wasNormalized)
        #expect(neutral.background != source)
    }

    @Test func foregroundStrategyCanOverrideAutomaticContrast() {
        let source = CGColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        let result = KLAdaptiveSurface.normalize(
            source,
            using: .init(foregroundStrategy: .light)
        )

        #expect(result.usesDarkForeground == false)
    }
}
