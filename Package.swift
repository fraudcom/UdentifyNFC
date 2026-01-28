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
        .package(url: "https://github.com/fraudcom/UdentifyCommons.git", .exact("25.4.0"))
    ],
    targets: [
        .binaryTarget(
            name: "UdentifyNFC",
            url: "https://api.github.com/repos/fraudcom/mobile/releases/assets/330210240.zip",
            checksum: "3de22bce5a12261e04ac56f5f7ad3fb9746500c672336abec5cc6840a6315ad6"
        )
    ]
)
