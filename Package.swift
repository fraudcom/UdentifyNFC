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
        .package(url: "https://github.com/fraudcom/UdentifyCommons.git", .exact("26.3.0814"))
    ],
    targets: [
        .binaryTarget(
            name: "UdentifyNFC",
            url: "https://api.github.com/repos/fraudcom/mobile/releases/assets/514147606.zip",
            checksum: "555f9f667e5ee2fcd905a025fc78c4223a7ee81e086a4ac02432c920f2b8672f"
        )
    ]
)
