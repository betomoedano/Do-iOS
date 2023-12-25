//
//  Item.swift
//  Do
//
//  Created by Alberto Moedano on 12/23/23.
//

import Foundation
import SwiftData


enum Priority: Codable {
    case none
    case low
    case medium
    case high
}

@Model
final class Item {
  var title: String
  var note: String?
  var date: Date
  var itRepeats: Bool
  var priority: Priority
  var timestamp: Date
    
  init(
    title: String,
    note: String? = nil,
    date: Date = Date.now,
    itRepeats: Bool = false,
    priority: Priority = .none,
    timestamp: Date = Date.now
  ) {
    self.title = title
    self.note = note
    self.date = date
    self.itRepeats = itRepeats
    self.priority = priority
    self.timestamp = timestamp
  }
}

