// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "HALAudio",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(
            name: "HALAudio",
            targets: ["HALAudio"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.94.1")
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
