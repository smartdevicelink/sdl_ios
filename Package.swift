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
        .package(name: "BiSON", url: "https://github.com/smartdevicelink/bson_c_lib.git", from: "1.2.2")
    ],
    targets: [
        .target(
            name: "SmartDeviceLink",
            dependencies: ["BiSON"],
            path: "SmartDeviceLink",
            exclude: ["Info.plist"],
            resources: [.process("Assets")],
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
