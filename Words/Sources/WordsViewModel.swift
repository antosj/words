//
//  WordsViewModel.swift
//  Words
//
//  Created by Anton Selivonchyk on 19/09/2023.
//

import Foundation
import Combine

enum Filter: String, CaseIterable {
    case frequency
    case alphabetically
    case length
}

class WordsViewModel {
    private let fileName: String
    private var wordsCounts: [String: Int]

    @Published var words = [String]()
    @Published var currentFilter: Filter

    var selectedSegmentIndex: Int {
        Filter.allCases.firstIndex(of: currentFilter) ?? 0
    }

    public init(fileName: String, wordsCounts: [String: Int] = [String: Int](), currentFilter: Filter = Filter.frequency) {
        self.fileName = fileName
        self.wordsCounts = wordsCounts
        self.currentFilter = currentFilter
    }

    public func loadData() {
        Task {
            try await readWords()
            apply(filter: currentFilter)
        }
    }

    public func apply(filter: Filter) {
        currentFilter = filter

        switch currentFilter {
        case .frequency:
            words = wordsCounts
                .sorted { $0.value > $1.value }
                .map { "\($0): \($1)"}
        case .alphabetically:
            words = wordsCounts.keys.sorted()
        case .length:
            words = wordsCounts
                .keys
                .sorted(by: {
                    $0.lengthOfBytes(using: .utf16) > $1.lengthOfBytes(using: .utf16)
                })
        }
    }

    // MARK: Private interface
    private func readWords() async throws {
        wordsCounts = try await Bundle.main.readFile(named: fileName)
    }
}
