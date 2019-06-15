// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
