import CoreGraphics
import KLAdaptiveSurface
import SwiftUI

@main
struct ReadingSurfaceDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ReadingSurfaceDemoView()
        }
    }
}

private struct ReadingSurfaceDemoView: View {
    var body: some View {
        let result = KLAdaptiveSurface.normalize(
            CGColor(red: 0.43, green: 0.25, blue: 0.18, alpha: 1)
        )

        VStack(alignment: .leading, spacing: 16) {
            Text("Reading surface")
                .font(.title2.weight(.semibold))
            Text("A photo-derived color is normalized only when it falls outside the readable range.")
                .foregroundStyle(Color(result.foreground))
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(result.background))
    }
}
