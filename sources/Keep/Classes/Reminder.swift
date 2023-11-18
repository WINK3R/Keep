//
//  Reminder.swift
//  Keep
//
//  Created by Lucas Delanier on 16/11/2023.
//

import Foundation

struct Reminder: Identifiable, Codable {
    var id = UUID()
    var title: String
    var date: Date
    var emoji: String
}
