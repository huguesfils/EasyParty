// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Settings",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Settings",
            targets: ["Settings"]),
    ],
    dependencies: [
        .package(path: "../TechLibs/CloudDBClient"),
        .package(path: "../TechLibs/SharedDomain"),
        .package(path: "../Features/Auth")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Settings",
            dependencies: [
                "CloudDBClient", "SharedDomain", "Auth"
            ]),
        .testTarget(
            name: "SettingsTests",
            dependencies: ["Settings"]),
    ]
)
