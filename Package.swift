// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "SmartDeviceLink",
    products: [
        .library(name: "SmartDeviceLink", targets: ["SmartDeviceLink"]),
        .library(name: "SmartDeviceLinkSwift", targets: ["SmartDeviceLinkSwift"])
    ],
    targets: [
        .target(
            name: "SmartDeviceLink",
            path: "SmartDeviceLink"
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
