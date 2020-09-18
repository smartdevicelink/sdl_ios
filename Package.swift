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
    targets: [
        .target(
            name: "SmartDeviceLink",
            dependencies: ["BiSON"],
            path: "SmartDeviceLink",
            exclude: ["Info.plist"],
            publicHeadersPath: "public"
        ),
        .target(
            name: "SmartDeviceLinkSwift",
            dependencies: ["SmartDeviceLink"],
            path: "SmartDeviceLinkSwift",
            exclude: ["Info.plist"]
        ),
        .target(
            name: "BiSON",
            path: "bson_c_lib/src"
        )
    ]
)
