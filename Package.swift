// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "UdentifyNFC",
    products: [
        .library(
            name: "UdentifyNFC",
            targets: ["UdentifyNFC"]),
    ],
    dependencies: [
        // Specify the dependency on `UdentifyCommons` with its repository URL and version or branch.
        .package(url: "https://github.com/fraudcom/UdentifyCommons.git", .exact("26.3.0928"))
    ],
    targets: [
        .binaryTarget(
            name: "UdentifyNFC",
            url: "https://api.github.com/repos/fraudcom/mobile/releases/assets/595145035.zip",
            checksum: "2074309bd75305ecfe154485d28241100dd6e15a4ede73c6e651e88f3a787828"
        )
    ]
)
