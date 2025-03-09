//
//  AwakenedEnhancement.swift
//
//
//  Created by Tadashi Kimura on 2025/03/02.
//
//  MIT License
//  Copyright (c) 2025 Tadashi Kimura
//  See the LICENSE file for details.
//

import Foundation
import ArgumentParser

struct AwakenedEnhancement: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "ae",
        abstract: "A tool to simulate awakened enhancement in a game."
    )

    @Option(name: .shortAndLong, help: "Specify the maximum awakened enhancement level.")
    var maxLevel: Int = 9

    @Option(name: .shortAndLong, help: "Specify the number of trials. Defaults to 1000.")
    var trials: Int = 1000

    static let verbosePrint = false

    static func printVerbose(_ message: String) {
        if verbosePrint {
            print(message)
        }
    }

    func run() async throws {
        try checkArguments()
        let numberOfTasks = 4
        let dividedTrials = (0..<4).map { $0 < trials % 4 ? trials / 4 + 1 : trials / 4 }
        let command = self
        let results = try await withThrowingTaskGroup(of: [Self.Simulator.Result].self) { group in
            (0..<numberOfTasks).forEach { index in
                group.addTask {
                    return try command.simulate(for: dividedTrials[index])
                }
            }
            return try await group.reduce([]) { $0 + $1 }
        }
        output(results: results)
    }

    private func checkArguments() throws {
        if maxLevel > 9 {
            throw ValidationError("Error: maxLevel cannot exceed 9. Please specify a value between 1 and 9.")
        }
    }

    private func simulate(for givenCount: Int) throws -> [Self.Simulator.Result] {
        Self.printVerbose("--- start simulation (\(givenCount)) ---")
        var results = [Self.Simulator.Result]()
        for _ in 0...givenCount {
            var simulator = Simulator()
            let result = try simulator.simulate(to: maxLevel)
            results.append(result)
        }
        return results
    }

    private func output(results: [Self.Simulator.Result]) {
        let sortedResults = results.sorted { $0.count < $1.count }
        let counts = Array(sortedResults.map { Double($0.count) })
        let resultAverage = sortedResults.average()
        print("The maximum level is \(maxLevel)")
        print("---------- average ----------")
        print(resultAverage)
        print("---------- min ----------")
        print(sortedResults.first!)
        print("---------- max ----------")
        print(sortedResults.last!)
        print("---------- standard ----------")
        print("standardDeviation = \(Int(counts.standardDeviation()))")
        let upperBounds = Int(counts.upperBound(nSigma: 2))
        let last = sortedResults.last(where: { $0.count < upperBounds })!
        print(last)
    }
}

extension AwakenedEnhancement {
    struct Simulator {
        struct Result {
            let count: Int
            let usedRecoveryTickets: Int
            let usedAcrumVs: Int
            let usedAcrumXs: Int
        }
        struct State {
            var count = 0
            var level = 0
            var usedRecoveryTickets = 0
            var usedAcrumVs = 0
            var usedAcrumXs = 0
        }
        private(set) var state = Self.State()
    }
}

extension AwakenedEnhancement.Simulator.Result {
    var numberOfSliverForOneEnhancement: Int {
        500_000
    }
    var numberOfRecoveryTickets: Int {
        200
    }

    var numberOfUsedSliver: Int {
        count * numberOfSliverForOneEnhancement
    }

    var numberOfUsedRecoveryTickets: Int {
        usedRecoveryTickets * numberOfRecoveryTickets
    }
}

extension AwakenedEnhancement.Simulator.Result: CustomStringConvertible {
    var description: String {
        buildDescription()
    }

    @DescriptionBuilder
    func buildDescription() -> String {
        "count = \(count)\n"
        let formatter = { () -> NumberFormatter in
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
        let formattedSliver = formatter.string(from: NSNumber(value: numberOfUsedSliver))!
        "sliver = \(formattedSliver)\n"
        let formattedRecoveryTickets = formatter.string(from: NSNumber(value: numberOfUsedRecoveryTickets))!
        "usedRecoveryTickets = \(formattedRecoveryTickets)\n"
        "usedAcrumVs = \(usedAcrumVs)\n"
        "usedAcrumXs = \(usedAcrumXs)\n"
    }
}

extension Array where Element == AwakenedEnhancement.Simulator.Result {
    func average() -> AwakenedEnhancement.Simulator.Result {
        let counts = self.map { Double($0.count) }
        let usedRecoveryTickets = self.map { Double($0.usedRecoveryTickets) }
        let usedAcrumVs = self.map { Double($0.usedAcrumVs) }
        let usedAcrumXs = self.map { Double($0.usedAcrumXs) }
        return AwakenedEnhancement.Simulator.Result(
            count: Int(counts.average()),
            usedRecoveryTickets: Int(usedRecoveryTickets.average()),
            usedAcrumVs: Int(usedAcrumVs.average()),
            usedAcrumXs: Int(usedAcrumXs.average())
        )
    }
 }

extension AwakenedEnhancement.Simulator.Result {
    init(from state: AwakenedEnhancement.Simulator.State) {
        count = state.count
        usedRecoveryTickets = state.usedRecoveryTickets
        usedAcrumVs = state.usedAcrumVs
        usedAcrumXs = state.usedAcrumXs
    }
}

extension AwakenedEnhancement.Simulator {
    enum Acrum: Int {
        case none = 10
        case v = 15
        case x = 20
        var probability: Double {
            Double(rawValue) / 10
        }
    }

    static let probabilities = [
        0: 80,
        1: 60,
        2: 40,
        3: 20,
        4: 10,
        5:  7,
        6:  6,
        7:  3,
        8:  1,
        9:  1,
        10: 1,
    ]

    static func probability(from level: Int, with acrum: Acrum) -> Int {
        guard let probability = Self.probabilities[level] else { return 0 }
        return Int(Double(probability) * acrum.probability)
    }

    struct Condition {
        let useRecoveryTicket: Bool
        let acrum: Acrum
    }

    static let conditions = [
        0:  Condition(useRecoveryTicket: false, acrum: Acrum.none),
        1:  Condition(useRecoveryTicket: false, acrum: Acrum.none),
        2:  Condition(useRecoveryTicket: false, acrum: Acrum.none),
        3:  Condition(useRecoveryTicket: false, acrum: Acrum.v),
        4:  Condition(useRecoveryTicket: true, acrum: Acrum.v),
        5:  Condition(useRecoveryTicket: true, acrum: Acrum.x),
        6:  Condition(useRecoveryTicket: true, acrum: Acrum.x),
        7:  Condition(useRecoveryTicket: true, acrum: Acrum.x),
        8:  Condition(useRecoveryTicket: true, acrum: Acrum.x),
        9:  Condition(useRecoveryTicket: true, acrum: Acrum.x),
        10: Condition(useRecoveryTicket: true, acrum: Acrum.x),
    ]

    static func challenge(with probability: Int) -> Bool {
        let result = Int.random(in: 1...100)
        return result <= probability
    }

    enum CommandError: Error {
        case conditionNotFound
    }

    mutating func simulate(to targetLevel: Int) throws -> Self.Result {
        while state.level < targetLevel {
            try simulate()
        }
        return .init(from: state)
    }

    mutating func simulate() throws {
        let level = state.level
        guard let condition = Self.conditions[level] else { throw CommandError.conditionNotFound }
        state.count += 1
        if Self.challenge(with: Self.probability(from: level, with: condition.acrum)) {
            state.level = level + 1
        } else if level > 0 {
            state.level = level - 1
            if condition.useRecoveryTicket {
                restoreOnRecoverySuccess(to: level)
            }
        }
        switch condition.acrum {
        case .none: break
        case .v: state.usedAcrumVs += 1
        case .x: state.usedAcrumXs += 1
        }
    }

    mutating func restoreOnRecoverySuccess(to level: Int) {
        state.usedRecoveryTickets += 1
        if Self.challenge(with: 50) {
            state.level = level
        }
    }
}
