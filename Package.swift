// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TunnelKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v17)
    ],
    products: [
        .library(
            name: "TunnelKit",
            targets: ["TunnelKit"]
        ),
        .library(
            name: "TunnelKitOpenVPN",
            targets: ["TunnelKitOpenVPN"]
        ),
        .library(
            name: "TunnelKitOpenVPNAppExtension",
            targets: ["TunnelKitOpenVPNAppExtension"]
        ),
        .library(
            name: "TunnelKitWireGuard",
            targets: ["TunnelKitWireGuard"]
        ),
        .library(
            name: "TunnelKitWireGuardAppExtension",
            targets: ["TunnelKitWireGuardAppExtension"]
        ),
        .library(
            name: "TunnelKitLZO",
            targets: ["TunnelKitLZO"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(
            url: "https://github.com/SwiftyBeaver/SwiftyBeaver",
            from: "1.9.0"
        ),
        .package(
            url: "https://github.com/passepartoutvpn/openssl-apple",
            from: "3.2.105"
        ),
        // WireGuard Apple – pakai versi yang manifest-nya kompatibel dengan SPM/Xcode
        .package(
            url: "https://github.com/JooAndriano/wireguard-apple.git",
            branch: "master"
        )
        // Alternatif kalau nanti mau pakai local path:
        // .package(name: "wireguard-apple", path: "../wireguard-apple")
    ],
    targets: [
        .target(
            name: "TunnelKit",
            dependencies: [
                "TunnelKitCore",
                "TunnelKitManager"
            ]
        ),
        .target(
            name: "TunnelKitCore",
            dependencies: [
                "__TunnelKitUtils",
                "CTunnelKitCore",
                "SwiftyBeaver"
            ]
        ),
        .target(
            name: "TunnelKitManager",
            dependencies: [
                "SwiftyBeaver"
            ]
        ),
        .target(
            name: "TunnelKitAppExtension",
            dependencies: [
                "TunnelKitCore"
            ]
        ),

        // OpenVPN
        .target(
            name: "TunnelKitOpenVPN",
            dependencies: [
                "TunnelKitOpenVPNCore",
                "TunnelKitOpenVPNManager"
            ]
        ),
        .target(
            name: "TunnelKitOpenVPNCore",
            dependencies: [
                "TunnelKitCore",
                "CTunnelKitOpenVPNCore",
                "CTunnelKitOpenVPNProtocol" // FIXME: remove dependency on TLSBox
            ]
        ),
        .target(
            name: "TunnelKitOpenVPNManager",
            dependencies: [
                "TunnelKitManager",
                "TunnelKitOpenVPNCore"
            ]
        ),
        .target(
            name: "TunnelKitOpenVPNProtocol",
            dependencies: [
                "TunnelKitOpenVPNCore",
                "CTunnelKitOpenVPNProtocol"
            ]
        ),
        .target(
            name: "TunnelKitOpenVPNAppExtension",
            dependencies: [
                "TunnelKitAppExtension",
                "TunnelKitOpenVPNCore",
                "TunnelKitOpenVPNManager",
                "TunnelKitOpenVPNProtocol"
            ]
        ),

        // WireGuard
        .target(
            name: "TunnelKitWireGuard",
            dependencies: [
                "TunnelKitWireGuardCore",
                "TunnelKitWireGuardManager"
            ]
        ),
        .target(
            name: "TunnelKitWireGuardCore",
            dependencies: [
                "__TunnelKitUtils",
                "TunnelKitCore",
                .product(name: "WireGuardKit", package: "wireguard-apple"),
                "SwiftyBeaver"
            ]
        ),
        .target(
            name: "TunnelKitWireGuardManager",
            dependencies: [
                "TunnelKitManager",
                "TunnelKitWireGuardCore"
            ]
        ),
        .target(
            name: "TunnelKitWireGuardAppExtension",
            dependencies: [
                "TunnelKitWireGuardCore",
                "TunnelKitWireGuardManager"
            ]
        ),

        // LZO
        .target(
            name: "TunnelKitLZO",
            dependencies: [],
            exclude: [
                "lib/COPYING",
                "lib/Makefile",
                "lib/README.LZO",
                "lib/testmini.c"
            ]
        ),

        // C targets
        .target(
            name: "CTunnelKitCore",
            dependencies: []
        ),
        .target(
            name: "CTunnelKitOpenVPNCore",
            dependencies: []
        ),
        .target(
            name: "CTunnelKitOpenVPNProtocol",
            dependencies: [
                "CTunnelKitCore",
                "CTunnelKitOpenVPNCore",
                "openssl-apple"
            ]
        ),
        .target(
            name: "__TunnelKitUtils",
            dependencies: []
        ),

        // Tests
        .testTarget(
            name: "TunnelKitCoreTests",
            dependencies: [
                "TunnelKitCore"
            ],
            exclude: [
                "RandomTests.swift",
                "RawPerformanceTests.swift",
                "RoutingTests.swift"
            ]
        ),
        .testTarget(
            name: "TunnelKitOpenVPNTests",
            dependencies: [
                "TunnelKitOpenVPNCore",
                "TunnelKitOpenVPNAppExtension",
                "TunnelKitLZO"
            ],
            exclude: [
                "DataPathPerformanceTests.swift",
                "EncryptionPerformanceTests.swift"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "TunnelKitLZOTests",
            dependencies: [
                "TunnelKitCore",
                "TunnelKitLZO"
            ]
        )
    ]
)