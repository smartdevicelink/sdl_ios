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
            path: "SmartDeviceLink",
//            resources: [
//                .process("SDLAssets.xcassets"),
//                .process("SDLLockScreen.storyboard")
//            ]
            publicHeadersPath: "SmartDeviceLink/public"
        ),
        .target(
            name: "SmartDeviceLinkSwift",
            dependencies: [
                "SmartDeviceLink"
            ],
            path: "SmartDeviceLinkSwift"
        ),
    ]
)
