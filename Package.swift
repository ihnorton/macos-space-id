// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SpaceID",
    platforms: [.macOS(.v13)],
    targets: [
        // Thin C shim that declares the private CoreGraphics symbols.
        // The actual symbols are exported by CoreGraphics.framework at link time.
        .target(
            name: "CGSBridge",
            path: "Sources/CGSBridge",
            publicHeadersPath: "include"
        ),
        .executableTarget(
            name: "SpaceID",
            dependencies: ["CGSBridge"],
            path: "Sources/SpaceID"
        ),
    ]
)
