// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "BaseNetworkKit",
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
