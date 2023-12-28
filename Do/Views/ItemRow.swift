//
//  ItemRow.swift
//  Do
//
//  Created by Alberto Moedano on 12/27/23.
//

import SwiftUI

struct ItemRow: View {
  var item: Item
  @State private var showDetails: Bool = false

  var body: some View {
    
    DisclosureGroup(
      content: { 
        VStack {
          Text(item.date.description)
          Text(item.note ?? "")
          Text(item.priority.rawValue)
          Text(item.timestamp.description)
        }
        .transition(.move(edge: .bottom))
      },
      label: {
        HStack {
          statusCircle
          VStack(alignment: .leading) {
            Text(item.title)
            ControlGroup {
                Text(item.status.rawValue)
//                Text(item.date.formatted(date: .abbreviated, time: .shortened))
            }
            .font(.caption2)
            .foregroundColor(.secondary)
            
          }
        }
      }
    )
    .buttonStyle(PlainButtonStyle()).accentColor(.clear).disabled(true)
  }
  
  private var statusCircle: some View {
      Circle()
        .fill(colorForStatus(item.status))
        .frame(width: 15)
  }

  private func colorForStatus(_ status: Status) -> Color {
      switch status {
      case .notStarted:
          return .gray
      case .inProgress:
          return .blue
      case .completed:
          return .green
      case .onHold:
          return .orange
      }
  }
}

#Preview {
  List {
    ItemRow(
      item: Item.init(
        title: "Camping Trip",
        note: "This is a description for a camping trip ficticious trip that does not exists",
        status: Status.completed,
        tag: Tag.hobby,
        date: Date.now,
        priority: Priority.high,
        timestamp: Date.distantFuture
      )
    )
    ItemRow(
      item: Item.init(
        title: "Camping Trip",
        note: "This is a description for a camping trip ficticious trip that does not exists",
        status: Status.completed,
        tag: Tag.hobby,
        date: Date.now,
        priority: Priority.high,
        timestamp: Date.distantFuture
      )
    )
    ItemRow(
      item: Item.init(
        title: "Camping Trip",
        note: "This is a description for a camping trip ficticious trip that does not exists",
        status: Status.completed,
        tag: Tag.hobby,
        date: Date.now,
        priority: Priority.high,
        timestamp: Date.distantFuture
      )
    )
    ItemRow(
      item: Item.init(
        title: "Camping Trip",
        note: "This is a description for a camping trip ficticious trip that does not exists",
        status: Status.completed,
        tag: Tag.hobby,
        date: Date.now,
        priority: Priority.high,
        timestamp: Date.distantFuture
      )
    )
  }
}
