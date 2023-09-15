// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "ScalingHeaderScrollView", 
            dependencies: [
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect")],
            path: "Source"),
    ],
    swiftLanguageVersions: [.v5]
)
