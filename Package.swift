// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SmartDeviceLink",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "SmartDeviceLink", targets: ["SmartDeviceLink"]),
        .library(name: "SmartDeviceLinkSwift", targets: ["SmartDeviceLinkSwift"])
    ],
    dependencies: [
        .package(name: "BiSON", url: "https://github.com/smartdevicelink/bson_c_lib.git", .branch("feature/swift_pm_support"))
    ],
    targets: [
        .target(
            name: "SmartDeviceLink",
            dependencies: ["BiSON"],
            path: "SmartDeviceLink",
            exclude: ["Info.plist"],
            resources: [
                .process("Assets")
//                .process("Assets/SDLAssets.xcassets"),
//                .process("Assets/Base.lproj"),
//                .process("Assets/de.lproj"),
//                .process("Assets/en.lproj"),
//                .process("Assets/es.lproj"),
//                .process("Assets/fr.lproj"),
//                .process("Assets/ja.lproj"),
//                .process("Assets/zh-Hans.lproj")
            ],
            publicHeadersPath: "public",
            cSettings: [
                .headerSearchPath("private")
            ]
        ),
        .target(
            name: "SmartDeviceLinkSwift",
            dependencies: ["SmartDeviceLink"],
            path: "SmartDeviceLinkSwift",
            exclude: ["Info.plist"]
        )
    ]
)
