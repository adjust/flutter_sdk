// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "adjust_sdk",
  platforms: [
    .iOS("12.0"),
  ],
  products: [
    .library(name: "adjust-sdk", targets: ["adjust_sdk"]),
  ],
  dependencies: [
    .package(url: "https://github.com/adjust/ios_sdk.git", exact: "5.6.2"),
  ],
  targets: [
    .target(
      name: "adjust_sdk",
      dependencies: [
        .product(name: "AdjustSdk", package: "ios_sdk"),
      ],
      cSettings: [
        .headerSearchPath("include/adjust_sdk"),
      ]
    ),
  ]
)
