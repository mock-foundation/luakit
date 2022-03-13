// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "LuaKit",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "LuaKit",
            targets: ["LuaKit"]),
    ],
    dependencies: [],
    targets: [
        .systemLibrary(
            name: "liblua",
            pkgConfig: "lua-5.4",
            providers: [
                .brewItem(["lua"])
            ]
        ),
        .target(
            name: "LuaKit",
            dependencies: ["liblua"],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-validate-tbd-against-ir=none"])
            ]
        ),
        .testTarget(
            name: "LuaKitTests",
            dependencies: ["LuaKit"]),
    ]
)
