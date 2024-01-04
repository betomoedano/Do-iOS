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
    Button {
      withAnimation {
        showDetails.toggle()
      }
    } label: {
      HStack {
        statusCircle
        VStack(alignment: .leading) {
        Text("Due Date on \(item.date.formatted(date: .abbreviated, time: .shortened))")
            .font(.caption2)
        Text("Created on \(item.timestamp.formatted(date: .abbreviated, time: .shortened))")
            .font(.caption2)
          Text(item.title)
          Text(item.status.rawValue)
            .font(.caption2)
            .foregroundColor(.secondary)
        }
        Spacer()
        VStack(alignment: .trailing, content: {
          Text(item.priority == .none ? "" : getPriorityAndColor(item.priority)?.0 ?? "")
            .foregroundColor(getPriorityAndColor(item.priority)?.1 ?? Color.clear)
            .font(.footnote)
          Text(item.date.formatted(date: .omitted, time: .shortened))
            .font(.caption2)
            .foregroundColor(.secondary)
        })
      }
    }
    .foregroundColor(.primary)
    if showDetails {
      VStack(alignment: .leading) {
        if let note = item.note, !note.isEmpty {
          Text(note)
            .font(.footnote)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
        }
        Text("Due Date on \(item.date.formatted(date: .abbreviated, time: .shortened))")
          .font(.caption2)
          .foregroundColor(.secondary)
          .fontWeight(.bold)
        Text("Created on \(item.timestamp.formatted(date: .abbreviated, time: .shortened))")
          .font(.caption2)
          .foregroundColor(.secondary)
      }
    }
  }
  
  private func getPriorityAndColor(_ priority: Priority) -> (String, Color)? {
    switch priority {
      case .none:
        return nil
      case .low:
        return ("!", Color.yellow)
      case .medium:
        return ("!!", Color.orange)
      case .high:
        return ("!!!", Color.red)
    }
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
  
  private func getImageNameForPriority(priority: Priority) -> String {
    switch priority {
      case .high:
        return "exclamationmark.3"
      case .medium:
        return "exclamationmark.2"
      case .low:
        return "exclamationmark"
      case .none:
        return ""
    }
  }
}

#Preview {
  List {
    ItemRow(
      item: Item.init(
        title: "Camping Trip",
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
        priority: Priority.medium,
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
        priority: Priority.low,
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
        priority: Priority.none,
        timestamp: Date.distantFuture
      )
    )
  }
}
