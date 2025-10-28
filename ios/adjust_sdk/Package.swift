// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "adjust_sdk",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "adjust-sdk", targets: ["adjust_sdk"])
    ],
    dependencies: [
        .package(url: "https://github.com/adjust/ios_sdk.git", from: "5.4.3")
    ],
    targets: [
        .target(
            name: "adjust_sdk",
            dependencies: [
                .product(name: "AdjustSdk", package: "ios_sdk")
            ],
            resources: [],
            cSettings: [
                .headerSearchPath("include/adjust_sdk")
            ]
        )
    ]
)