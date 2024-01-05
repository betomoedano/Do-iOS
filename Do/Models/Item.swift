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

enum Period: String, CaseIterable, Identifiable {
    case today = "Today"
    case nextSevenDays = "Next 7 Days"
    case nextThirtyDays = "Next 30 Days"
    case future = "Future"
    case past = "Past"
    
    var id: String { self.rawValue }
    var name: String { self.rawValue }
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
  var period: Period {
      let now = Date.now
      let today = Calendar.current.startOfDay(for: now)
      let oneDayOut = Calendar.current.date(byAdding: .day, value: 1, to: today)!
      let sevenDaysOut = Calendar.current.date(byAdding: .day, value: 7, to: today)!
      let thirtyDaysOut = Calendar.current.date(byAdding: .day, value: 30, to: today)!

      if date < today {
          return .past
      } else if date < oneDayOut {
          return .today
      } else if date < sevenDaysOut {
          return .nextSevenDays
      } else if date < thirtyDaysOut {
          return .nextThirtyDays
      } else {
          return .future
      }
  }
    
  
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

// Convenience methods for dates.
extension Date {
    var oneDayOut: Date {
        Calendar.autoupdatingCurrent.date(byAdding: .day, value: 1, to: self) ?? self
    }
    var sevenDaysOut: Date {
        Calendar.autoupdatingCurrent.date(byAdding: .day, value: 7, to: self) ?? self
    }
    
    var thirtyDaysOut: Date {
        Calendar.autoupdatingCurrent.date(byAdding: .day, value: 30, to: self) ?? self
    }
}

extension Date {
    static func from(month: Int, day: Int, year: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let calendar = Calendar(identifier: .gregorian)
        if let date = calendar.date(from: dateComponents) {
            return date
        } else {
            return Date.now
        }
    }

    static func roundedHoursFromNow(_ hours: Double) -> Date {
        let exactDate = Date(timeIntervalSinceNow: hours)
        guard let hourRange = Calendar.current.dateInterval(of: .hour, for: exactDate) else {
            return exactDate
        }
        return hourRange.end
    }
}

extension Collection where Element == Item {
    func groupedByPeriod() -> [Period: [Item]] {
        return Dictionary(grouping: self, by: { $0.period })
    }
}

