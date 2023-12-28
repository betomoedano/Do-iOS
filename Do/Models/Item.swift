//
//  Item.swift
//  Do
//
//  Created by Alberto Moedano on 12/23/23.
//

import Foundation
import SwiftData


enum Priority: String, Codable, CaseIterable {
  case none
  case low
  case medium
  case high
  
  var id: String { self.rawValue }
  var name: String { self.rawValue }
}

enum Tag: String, Codable, CaseIterable {
  case none
  case work
  case personal
  case study
  case hobby
  case social
  
  var id: String { self.rawValue }
}

enum Status: String, Codable, CaseIterable {
  case notStarted = "Not Started"
  case inProgress = "In Progress"
  case completed = "Completed"
  case onHold = "On Hold"
  
  
  var id: String { self.rawValue }
}


@Model
final class Item: Identifiable, Hashable {
  var id = UUID()
  var title: String
  var note: String?
  var status: Status
  var tag: Tag
  var date: Date
  var priority: Priority
  var timestamp: Date
    
  init(
    id: UUID = UUID(),
    title: String,
    note: String? = nil,
    status: Status = .notStarted,
    tag: Tag = .none,
    date: Date = Date.now,
    priority: Priority = .none,
    timestamp: Date = Date.now
  ) {
    self.id = id
    self.title = title
    self.note = note
    self.status = status
    self.tag = tag
    self.date = date
    self.priority = priority
    self.timestamp = timestamp
  }
   
}

