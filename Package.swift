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
    dependencies: [
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "ScalingHeaderScrollView", 
            dependencies: [
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect")
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ]
)
