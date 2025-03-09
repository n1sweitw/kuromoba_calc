//
//  DescriptionBuilder.swift
//
//
//  Created by Tadashi Kimura on 2025/03/02.
//
//  MIT License
//  Copyright (c) 2025 Tadashi Kimura
//  See the LICENSE file for details.
//

import Foundation

@resultBuilder
struct DescriptionBuilder {
    static func buildBlock(_ components: String...) -> String {
        return components.joined()
    }
}
