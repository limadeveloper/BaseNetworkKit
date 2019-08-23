// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "BaseNetworkKit",
  platforms: [
      .macOS(.v10_13),
      .iOS(.v10),
      .watchOS(.v3),
      .tvOS(.v9)
  ],
  products: [
    .library(
      name: "BaseNetworkKit",
      targets: ["BaseNetworkKit"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "BaseNetworkKit",
      dependencies: []
    ),
    .testTarget(
      name: "BaseNetworkKitTests",
      dependencies: ["BaseNetworkKit"]
    ),
  ]
)
