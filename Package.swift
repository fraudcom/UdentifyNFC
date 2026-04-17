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
            url: "https://api.github.com/repos/fraudcom/mobile/releases/assets/397881012.zip",
            checksum: "20bb3a456059f43199a26b09e54507928ad5995f815fef451753e2140379f4a5"
        )
    ]
)
