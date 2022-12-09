// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ValueAnimator",
    platforms: [
        .iOS(.v9), .tvOS(.v12), .macOS(.v10_10), .watchOS(.v2)
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
