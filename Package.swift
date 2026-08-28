// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "KLAdaptiveSurface",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "KLAdaptiveSurface",
            targets: ["KLAdaptiveSurface"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-docc-plugin",
            from: "1.4.0"
        )
    ],
    targets: [
        .target(name: "KLAdaptiveSurface"),
        .testTarget(
            name: "KLAdaptiveSurfaceTests",
            dependencies: ["KLAdaptiveSurface"]
        )
    ],
    swiftLanguageModes: [.v6]
)
