// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "swift-braintree",
    platforms: [
       .macOS(.v12)
    ],
    products: [
        .library(name: "Braintree", targets: ["Braintree"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/CoreOffice/XMLCoder", from: "0.14.0"),
    ],
    targets: [
        .target(
            name: "Braintree",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                "XMLCoder",
            ]
        ),
    ]
)
