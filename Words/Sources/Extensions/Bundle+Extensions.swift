//
//  Bundle+Extensions.swift
//  Words
//
//  Created by Anton Selivonchyk on 19/09/2023.
//

import Foundation

public enum BundleError: Error {
    case fileNotFound
}

extension Bundle {
    func readFile(named fileName: String) async throws -> [String: Int] {
        guard let urlpath = Bundle.main.path(forResource: fileName, ofType: nil) else {
            throw BundleError.fileNotFound
        }

        let url = URL(fileURLWithPath: urlpath)
        var words = [String: Int]()
        for try await line in url.lines {
            line.tokenized().forEach {
                words[$0, default: 0] += 1
            }
        }

        return words
    }
}
