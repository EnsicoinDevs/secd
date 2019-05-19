// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "secd",
	dependencies: [
		// Dependencies declare other packages that this package depends on.
		// .package(url: /* package url */, from: "1.0.0"),
		.package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
		.package(url: "https://github.com/heylelos/fileutils.git", .branch("master")),
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages which this package depends on.
		.target(
			name: "secd",
			dependencies: ["Logging", "FileUtils"]),
		.testTarget(
			name: "secdTests",
			dependencies: ["secd"]),
	]
)
