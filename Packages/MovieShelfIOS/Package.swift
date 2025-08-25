// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "MovieShelfIOS",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "MovieShelfIOS",
      targets: ["MovieShelfIOS"]
    ),
    .library(
      name: "MovieShelfKit",
      targets: ["MovieShelfKit"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/danielprast/BezetQit.git",
      from: Version("1.0.0")
    )
  ],
  targets: [
    .target(
      name: "MovieShelfIOS",
      dependencies: [
        "MovieShelfKit",
        .product(name: "BZUtil", package: "BezetQit")
      ]
    ),
    .target(
      name: "MovieShelfKit",
      dependencies: [
        .product(name: "BZConnectionChecker", package: "BezetQit"),
        .product(name: "BZUtil", package: "BezetQit")
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .testTarget(
      name: "MovieShelfIOSTests",
      dependencies: ["MovieShelfIOS"]
    ),
    .testTarget(
      name: "MovieShelfKitTests",
      dependencies: ["MovieShelfKit"]
    ),
  ]
)
