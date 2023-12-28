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
          Text(item.title)
          Text(item.status.rawValue)
            .font(.caption2)
            .foregroundColor(.secondary)
        }
        Spacer()
        Image(systemName: getImageNameForPriority(priority: item.priority))
          .foregroundColor(.secondary)
      }
    }
    .foregroundColor(.primary)
    .contextMenu(ContextMenu(menuItems: {
      Button {
                 // Add this item to a list of favorites.
             } label: {
                 Label("Add to Favorites", systemImage: "heart")
             }
             Button {
                 // Open Maps and center it on this item.
             } label: {
                 Label("Show in Maps", systemImage: "mappin")
             }
    }))
    
    if showDetails {
      VStack(alignment: .leading) {
        if let note = item.note, !note.isEmpty {
          Text(note)
        }
        Text("Due Date \(item.date.formatted(date: .abbreviated, time: .shortened))")
        Text("Created on \(item.timestamp.formatted(date: .abbreviated, time: .shortened))")
          .font(.caption2)
          .foregroundColor(.secondary)
      }
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
