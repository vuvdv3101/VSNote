// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VSNoteCore",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "VSNoteCore",
            targets: ["VSNoteCore"]),
    ],
    dependencies: [
        .package(
                url: "https://github.com/groue/GRDB.swift.git",
                from: "6.0.0"
            )
    ],
    targets: [
        .target(
            name: "VSNoteCore",
            dependencies: [
                .product(name: "GRDB", package: "GRDB.swift")
            ]),
        .testTarget(
            name: "VSNoteCoreTests",
            dependencies: ["VSNoteCore"]
        ),
    ]
)
