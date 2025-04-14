// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SignatureCanvas",
    platforms: [
        .macOS(.v14), .iOS(.v17)
    ],
    products: [
        .library(
            name: "SignatureCanvas",
            targets: ["SignatureCanvas"]),
        .executable(
            name: "TestApp",
            targets: ["TestApp"]),
    ],
    targets: [
        .target(
            name: "SignatureCanvas",
            dependencies: []),
        .executableTarget(
            name: "TestApp",
            dependencies: ["SignatureCanvas"]),
    ]
)
