// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "OLFUPortal",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "OLFUPortal",
            targets: ["OLFUPortal"]
        )
    ],
    targets: [
        .target(
            name: "OLFUPortal",
            path: "OLFUPortal"
        )
    ]
)
