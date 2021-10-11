// swift-tools-version:5.1

import PackageDescription

let package = Package(
	name: "ScalingHeaderView",
	platforms: [
		.macOS(.v11),
        .iOS(.v14),
        .watchOS(.v6),
        .tvOS(.v14)
    ],
    products: [
    	.library(
    		name: "ScalingHeaderView", 
    		targets: ["ScalingHeaderView"]
    	)
    ],
    targets: [
    	.target(
    		name: "ScalingHeaderView",
            path: "Source"
        )
    ],
    swiftLanguageVersions: [.v5]
)
