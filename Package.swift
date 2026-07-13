// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ScalingHeaderScrollView",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ScalingHeaderScrollView",
            targets: ["ScalingHeaderScrollView"]),
    ],
    targets: [
        .target(
            name: "ScalingHeaderScrollView",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ]
)
