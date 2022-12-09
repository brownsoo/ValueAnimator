// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ValueAnimator",
    platforms: [
        .iOS(.v11), .tvOS(.v12), .macOS(.v11), .watchOS(.v7)
    ],
    products: [
        .library(
            name: "ValueAnimator",
            targets: ["ValueAnimator"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        .target(
            name: "ValueAnimator",
            dependencies: []
        ),
        .testTarget(
            name: "ValueAnimatorTests",
            dependencies: ["ValueAnimator"]
        )
    ]
)
