// swift-tools-version: 6.4

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-contravariant",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [
        .library(name: "Contravariant Macro", targets: ["Contravariant Macro"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-algebra.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-product.git", branch: "main"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "603.0.2"..<"604.0.0")
    ],
    targets: [
        .target(
            name: "Contravariant Macro Core",
            dependencies: [
                .product(name: "Type Algebra Syntax", package: "swift-algebra"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ]
        ),
        .macro(
            name: "Contravariant Macro Plugin",
            dependencies: [
                "Contravariant Macro Core",
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "Contravariant Macro",
            dependencies: ["Contravariant Macro Plugin"]
        ),
        .testTarget(
            name: "Contravariant Macro Tests",
            dependencies: ["Contravariant Macro"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}

// Consumer compilation must reject visibility regressions, even when other packages suppress warnings.
for target in package.targets where target.type == .test || target.name.hasSuffix("Consumer Fixtures") {
    target.swiftSettings = (target.swiftSettings ?? []) + [.treatAllWarnings(as: .error)]
}
