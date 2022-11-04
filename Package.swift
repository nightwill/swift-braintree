// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Braintree",
    platforms: [
       .macOS(.v12)
    ],
    products: [
        .library(name: "Braintree", targets: ["Braintree"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/MihaelIsaev/XMLParsing.git", from: "0.1.0"),
        .package(url: "https://github.com/drmohundro/SWXMLHash.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "Braintree",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                "XMLParsing",
                "SWXMLHash"
            ]
        ),
    ]
)
