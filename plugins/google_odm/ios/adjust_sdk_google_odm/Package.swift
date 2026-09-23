// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "adjust_sdk_google_odm",
  platforms: [
    .iOS("12.0"),
  ],
  products: [
    .library(name: "adjust-sdk-google-odm", targets: ["adjust_sdk_google_odm"]),
  ],
  dependencies: [
    .package(url: "https://github.com/adjust/ios_sdk.git", exact: "5.8.0"),
  ],
  targets: [
    .target(
      name: "adjust_sdk_google_odm",
      dependencies: [
        .product(name: "AdjustGoogleOdm", package: "ios_sdk"),
      ],
      cSettings: [
        .headerSearchPath("include/adjust_sdk_google_odm"),
      ]
    ),
  ]
)
