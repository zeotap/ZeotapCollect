// swift-tools-version:5.3.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZeotapCollect",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ZeotapCollect",
            targets: ["ZeotapCollect"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    
      targets: [
          // Targets are the basic building blocks of a package. A target can define a module or a test suite.
          // Targets can depend on other targets in this package, and on products in packages this package depends on.
              .binaryTarget(
                  name: "ZeotapCollect",
                  url: "https://content.zeotap.com/ios-sdk/ios-collect-sdk.zip",
                  checksum: "7bed61e854fdba2853b74dfaed3065ff54c84b4aa287fa4f6d3896b1da56f9bb")
          ]
)
