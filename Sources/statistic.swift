//
//  statics.swift
//  
//  Created by Tadashi Kimura on 2025/03/02.
//
//  MIT License
//  Copyright (c) 2025 Tadashi Kimura
//  See the LICENSE file for details.
//

import Foundation

extension Array where Element == Double {
    func sum() -> Double {
        reduce(0.0, +)
    }

    func average() -> Double {
        sum()/Double(count)
    }

    func deviations() -> [Double] {
        let average = average()
        return map { $0 - average }
    }

    func variance() -> Double {
        deviations().map { pow($0, 2.0) }.average()
    }

    func standardDeviation() -> Double {
        sqrt(variance())
    }

    // nシグマ上限
    func upperBound(nSigma: Double) -> Double {
        average() + nSigma * standardDeviation()
    }

    // nシグマ下限（下限は0より小さくならない方がいいかも）
    func lowerBound(nSigma: Double) -> Double {
        average() - nSigma * standardDeviation()
    }
}
