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
            targets: ["LuaKit", "Lua"]),
    ],
    dependencies: [],
    targets: [
        .systemLibrary(
            name: "liblua",
            pkgConfig: "lua",
            providers: [
                .brewItem(["lua"])
            ]
        ),
        .target(
            name: "Lua",
            dependencies: ["liblua"]
        ),
        .target(
            name: "LuaKit",
            dependencies: ["liblua", "Lua"]
        ),
        .testTarget(
            name: "LuaKitTests",
            dependencies: ["LuaKit"]),
    ]
)
