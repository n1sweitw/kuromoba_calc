// The Swift Programming Language
// https://docs.swift.org/swift-book
//
//  Created by Tadashi Kimura on 2025/03/02.
//
//  MIT License
//  Copyright (c) 2025 Tadashi Kimura
//  See the LICENSE file for details.

import Foundation
import ArgumentParser

@main
struct KuromobaCalc: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "simulator of Black Desert mobile",
        subcommands: [AwakenedEnhancement.self,]
    )
}
