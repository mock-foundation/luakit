// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "LuaKit",
    products: [
        .library(
            name: "LuaKit",
            targets: ["LuaKit"]),
    ],
    dependencies: [],
    targets: [
        .systemLibrary(
            name: "liblua",
            pkgConfig: "liblua",
            providers: [
                .brewItem(["lua"])
            ]
        ),
        .target(
            name: "LuaKit",
            dependencies: ["liblua"]),
        .testTarget(
            name: "LuaKitTests",
            dependencies: ["LuaKit"]),
    ]
)
