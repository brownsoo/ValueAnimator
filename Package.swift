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
            targets: ["ValueAnimator-iOS",
                      "ValueAnimator-tvOS",
                      "ValueAnimator-macOS",
                      "ValueAnimator-watchOS"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
               
        .target(
            name: "ValueAnimatorExample",
            dependencies: ["ValueAnimator"]),
        .testTarget(
            name: "ValueAnimator-iOSTests",
            dependencies: ["ValueAnimator-iOS"]),
    ]
)
