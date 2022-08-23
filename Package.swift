// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "HALAudio",
    products: [
        .library(
            name: "HALAudio",
            targets: ["HALAudio"]),
    ],
    targets: [
        .target(
            name: "HALAudio"),
        .testTarget(
            name: "HALAudioTests",
            dependencies: ["HALAudio"]),
    ]
)
