//
//  UISegmentedControl+Extensions.swift
//  Words
//
//  Created by Anton Selivonchyk on 19/09/2023.
//

import UIKit

extension UISegmentedControl {
    func represent<T: RawRepresentable & CaseIterable>(type: T.Type) {
        removeAllSegments()

        type.allCases.enumerated().forEach {
            insertSegment(withTitle: "\($1)".capitalized,
                          at: $0,
                          animated: false)
        }
    }
}
