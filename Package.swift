// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "MSNavigationController",
    products: [
        .library(name: "MSNavigationController", targets: ["MSNavigationController"])
    ],
    targets: [
        .target(
            name: "MSNavigationController",
            path: "MSNavigationController"
        )
    ]
)
