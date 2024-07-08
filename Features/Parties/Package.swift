// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Parties",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Parties",
            targets: ["Parties"]),
    ],
    dependencies: [
        .package(path: "../TechLibs/CloudDBClient"),
        .package(path: "../TechLibs/SharedDomain"),
        .package(path: "../Features/Auth"),
        .package(path: "../Features/Settings")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Parties",
            dependencies: [
                "CloudDBClient", "SharedDomain", "Auth", "Settings"
            ]),
        .testTarget(
            name: "PartiesTests",
            dependencies: ["Parties"]),
    ]
)
