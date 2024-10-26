//
//  NumberFormatterExtension.swift
//  Super Shopper
//
//  Created by Nathan Guzman on 10/25/24.
//

// NumberFormatterExtension.swift

import Foundation

extension NumberFormatter {
    static var integer: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.maximumFractionDigits = 0
        formatter.zeroSymbol = "1"
        return formatter
    }
}
