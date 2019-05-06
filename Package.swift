// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "SmartDeviceLink-iOS",
    products: [
        .library(name: "SmartDeviceLinkSwift", targets: ["SmartDeviceLinkSwift"]),
        .library(name: "SmartDeviceLink", targets: ["SmartDeviceLink"])

    ],
    targets: [
        .target(
            name: "SmartDeviceLinkSwift",
            path: "SmartDeviceLinkSwift"
        ),
        .target(
            name: "SmartDeviceLink",
            path: "SmartDeviceLink"
        )
    ]
)

