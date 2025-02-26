// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension SwiftSetting {
    // swiftlint:disable line_length
    // Remove after Swift 6 support is enabled
    // https://github.com/swiftlang/swift/blob/3115f38053f02e364cf151ac94a422d25e6da86f/include/swift/Basic/Features.def#L207-L222
    static let conciseMagicFile: Self = .enableUpcomingFeature("ConciseMagicFile")                            // SE-0274
    static let forwardTrailingClosures: Self = .enableUpcomingFeature("ForwardTrailingClosures")              // SE-0286
    static let strictConcurrency: Self = .enableUpcomingFeature("StrictConcurrency")                          // SE-0337
    static let bareSlashRegexLiterals: Self = .enableUpcomingFeature("BareSlashRegexLiterals")                // SE-0354
    static let deprecateApplicationMain: Self = .enableUpcomingFeature("DeprecateApplicationMain")            // SE-0383
    static let importObjcForwardDeclarations: Self = .enableUpcomingFeature("ImportObjcForwardDeclarations")  // SE-0384
    static let disableOutwardActorInference: Self = .enableUpcomingFeature("DisableOutwardActorInference")    // SE-0401
    static let isolatedDefaultValues: Self = .enableUpcomingFeature("IsolatedDefaultValues")                  // SE-0411
    static let globalConcurrency: Self = .enableUpcomingFeature("GlobalConcurrency")                          // SE-0412
    static let inferSendableFromCaptures: Self = .enableUpcomingFeature("InferSendableFromCaptures")          // SE-0418
    static let implicitOpenExistentials: Self = .enableUpcomingFeature("ImplicitOpenExistentials")            // SE-0352
    static let regionBasedIsolation: Self = .enableUpcomingFeature("RegionBasedIsolation")                    // SE-0414
    static let dynamicActorIsolation: Self = .enableUpcomingFeature("DynamicActorIsolation")                  // SE-0423
    static let nonfrozenEnumExhaustivity: Self = .enableUpcomingFeature("NonfrozenEnumExhaustivity")          // SE-0192
    static let globalActorIsolatedTypesUsability: Self = .enableUpcomingFeature("GlobalActorIsolatedTypesUsability") // SE-0434

    // Keep even after Swift 6
    // https://github.com/swiftlang/swift/blob/3115f38053f02e364cf151ac94a422d25e6da86f/include/swift/Basic/Features.def#L224-L227
    static let existentialAny: Self = .enableUpcomingFeature("ExistentialAny")                                // SE-0335
    static let internalImportsByDefault: Self = .enableUpcomingFeature("InternalImportsByDefault")            // SE-0409
    static let memberImportVisibility: Self = .enableUpcomingFeature("MemberImportVisibility")                // SE-0444
    // swiftlint:enable line_length
}

let package = Package(
    name: "LocalPackage",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "LocalPackage", targets: ["GlobalActorIsolatedTypesUsability"]),
    ],
    targets: [
        .target(
            name: "GlobalActorIsolatedTypesUsability",
            swiftSettings: [
                .swiftLanguageMode(.v5),
                .conciseMagicFile,
                .forwardTrailingClosures,
                .strictConcurrency,
                .bareSlashRegexLiterals,
                .deprecateApplicationMain,
                .importObjcForwardDeclarations,
                .disableOutwardActorInference,
                .isolatedDefaultValues,
                .strictConcurrency,
                .globalConcurrency,
                .regionBasedIsolation,
                .regionBasedIsolation,
//                .globalActorIsolatedTypesUsability
            ])
    ]
)
