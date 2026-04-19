// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "HALAudio",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "HALAudio",
            targets: ["HALAudio"]),
    ],
    targets: [
        .target(
            name: "HALAudio"
        ),
        .testTarget(
            name: "HALAudioTests",
            dependencies: ["HALAudio"]
        ),
    ]
)
