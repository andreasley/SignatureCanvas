// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SignatureCanvas",
    platforms: [
        .macOS(.v12), .iOS(.v15), .tvOS(.v15)
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
