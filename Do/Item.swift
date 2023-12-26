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
final class ListOfItems: Identifiable, Hashable {
  var id = UUID()
  var title: String
  var about: String
  var emoji: String?
  var items: [Item]?
  
  init(id: UUID = UUID(), title: String, about: String, emoji: String? = nil, items: [Item]) {
    self.id = id
    self.title = title
    self.about = about
    self.emoji = emoji
    self.items = items
  }
}

@Model
final class Item: Identifiable, Hashable {
  var id = UUID()
  var title: String
  var note: String?
  var date: Date
  var itRepeats: Bool
  var priority: Priority
  var timestamp: Date
    
  init(
    id: UUID = UUID(),
    title: String,
    note: String? = nil,
    date: Date = Date.now,
    itRepeats: Bool = false,
    priority: Priority = .none,
    timestamp: Date = Date.now
  ) {
    self.id = id
    self.title = title
    self.note = note
    self.date = date
    self.itRepeats = itRepeats
    self.priority = priority
    self.timestamp = timestamp
  }
   
}

