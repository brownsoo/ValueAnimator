// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ValueAnimator",
    platforms: [
        .iOS(.v13), .tvOS(.v13), .macOS(.v10_15), .watchOS(.v6)
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
