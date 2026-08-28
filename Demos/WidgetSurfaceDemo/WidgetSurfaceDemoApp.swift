import CoreGraphics
import KLAdaptiveSurface
import SwiftUI

@main
struct WidgetSurfaceDemoApp: App {
    var body: some Scene {
        WindowGroup {
            WidgetSurfaceDemoView()
        }
    }
}

private struct WidgetSurfaceDemoView: View {
    @State private var normalizationEnabled = true
    @State private var strength = KLAdaptiveSurface.Configuration.reading.normalizationStrength

    var body: some View {
        let configuration = KLAdaptiveSurface.Configuration(
            isEnabled: normalizationEnabled,
            normalizationStrength: strength
        )
        let result = KLAdaptiveSurface.normalize(
            CGColor(red: 0.43, green: 0.25, blue: 0.18, alpha: 1),
            using: configuration
        )

        VStack(alignment: .leading, spacing: 12) {
            Text("Widget surface")
                .font(.headline)
            Toggle("Normalize image colors", isOn: $normalizationEnabled)
            Slider(value: $strength, in: 0...1) {
                Text("Strength")
            }
        }
        .foregroundStyle(Color(result.foreground))
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(result.background))
    }
}
