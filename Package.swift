// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "HALAudio",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "HALAudio",
            targets: ["HALAudio"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "HALAudio",
            dependencies: [.product(name: "NIOConcurrencyHelpers", package: "swift-nio")]
        ),
        .testTarget(
            name: "HALAudioTests",
            dependencies: ["HALAudio"]
        ),
    ]
)
