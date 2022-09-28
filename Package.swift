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
        // Dependencies declare other packages that this package depends on.
         .package(name: "Introspect", url: "https://github.com/siteline/SwiftUI-Introspect.git", from: "0.1.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ScalingHeaderScrollView",
            dependencies: ["Introspect"],
            path: "Source"),
    ],
    swiftLanguageVersions: [.v5]
)
