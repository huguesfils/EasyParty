// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CloudDBClient",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CloudDBClient",
            targets: ["CloudDBClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.28.0")
    ],
    targets: [
        .target(
            name: "CloudDBClient",
            dependencies: [
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ]
        ),
        .testTarget(
            name: "CloudDBClientTests",
            dependencies: ["CloudDBClient"]
        ),
    ]
)
