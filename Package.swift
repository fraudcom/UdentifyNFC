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
        .package(url: "https://github.com/fraudcom/UdentifyCommons.git", .exact("26.1.3"))
    ],
    targets: [
        .binaryTarget(
            name: "UdentifyNFC",
            url: "https://api.github.com/repos/fraudcom/mobile/releases/assets/397612083.zip",
            checksum: "5f54f77b8bf8bfdf824a56675031ba5af1fb2d3cdbe55646aa49d2fe81c2bd97"
        )
    ]
)
