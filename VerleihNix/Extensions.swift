//
//  Extensions.swift
//  VerleihNix
//
//  Created by Michael Milke on 29.10.24.
//

import Foundation

extension Date {
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
