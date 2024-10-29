//
//  VerleihItem.swift
//  VerleihNix
//
//  Created by Michael Milke on 29.10.24.
//

import Foundation

struct VerleihItem: Identifiable, Codable {
    var id = UUID()
    var itemName: String
    var lender: String
    var dateLent: Date
    var dateDue: Date
    var reminderDate: Date
}
