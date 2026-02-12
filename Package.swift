// swift-tools-version:5.10

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
        .package(url: "https://github.com/swhitty/swift-mutex.git", from: "0.0.5")
    ],
    targets: [
        .target(
            name: "HALAudio",
            dependencies: [.product(name: "Mutex", package: "swift-mutex")]
        ),
        .testTarget(
            name: "HALAudioTests",
            dependencies: ["HALAudio"]
        ),
    ]
)
