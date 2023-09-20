//
//  String+Extensions.swift
//  Words
//
//  Created by Anton Selivonchyk on 19/09/2023.
//

import Foundation

extension String {
    func tokenized() -> [Self] {
        let lowerCased = lowercased()

        let inputRange = CFRangeMake(0, lowerCased.utf16.count)
        let flag = UInt(kCFStringTokenizerUnitWord)
        let locale = CFLocaleCopyCurrent()
        let tokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, (lowerCased as CFString), inputRange, flag, locale)
        var tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        var tokens = [String]()

        while tokenType != [] {
            let currentTokenRange = CFStringTokenizerGetCurrentTokenRange(tokenizer)
            let substring = lowerCased.substringWithRange(currentTokenRange)
            tokens.append(substring)
            tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        }

        return tokens
    }

    // MARK: Private interface
    private func substringWithRange(_ range: CFRange) -> String {
        let nsrange = NSMakeRange(range.location, range.length)

        return (self as NSString).substring(with: nsrange)
    }
}
