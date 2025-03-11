//
//  ItemListView.swift
//  Do
//
//  Created by Alberto Moedano on 1/3/24.
//

import SwiftUI
import SwiftData

struct ItemListView: View {
  @Query private var items: [Item]
  @Environment(\.modelContext) private var modelContext
  @State private var showNewToDoSheet: Bool = false
  public var order: String
  public var isSingleList: Bool
  
  init(sort: SortDescriptor<Item>, order: String, isSingleList: Bool = false) {
    _items = Query(sort: [sort])
    self.order = order
    self.isSingleList = isSingleList
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(items[index])
      }
    }
  }
  
  var body: some View {
    if items.isEmpty {
      VStack {
        Button {
          showNewToDoSheet.toggle()
        } label: {
          Label {
            Text("Add new Task")
          } icon: {
            Image(systemName: "circle.inset.filled")
          }
        }
      }
      .sheet(isPresented: $showNewToDoSheet) {
        NewToDoSheet()
      }
    } else {
      List {
        if isSingleList {
          // Show all items in a single list
          ForEach(order == "ASC" ? items : items.reversed()) { item in
            ItemRow(item: item)
              .swipeActions { deleteAction(item) }
              .contextMenu { contextMenuItems(for: item) }
              .swipeActions(edge: .leading) { statusActions(for: item) }
          }
          .onDelete(perform: deleteItems)
        } else {
          // Show items grouped by period
          ForEach(Period.allCases) { period in
            let filteredItems = order == "ASC" ? items.filter { $0.period == period } : items.reversed().filter { $0.period == period }
            if !filteredItems.isEmpty {
              Section(header: Text(period.name.lowercased() == "today" ? "TODAY " + Date.now.formatted(date: .long, time: .omitted) : period.name)) {
                ForEach(filteredItems) { item in
                  ItemRow(item: item)
                    .swipeActions { deleteAction(item) }
                    .contextMenu { contextMenuItems(for: item) }
                    .swipeActions(edge: .leading) { statusActions(for: item) }
                }
                .onDelete(perform: deleteItems)
                .listRowSeparator(.hidden)
              }
            }
          }
        }
      }
    }
  }
  
  // Extracted functions for reusability
  private func deleteAction(_ item: Item) -> some View {
    Button(role: .destructive) {
      withAnimation {
        modelContext.delete(item)
      }
    } label: {
      Label("Delete", systemImage: "trash")
    }
  }
  
  private func contextMenuItems(for item: Item) -> some View {
    Group {
      Button { item.status = .completed } label: { Label("Complete", systemImage: "checkmark.circle") }
      Button { item.status = .notStarted } label: { Label("Not Started", systemImage: "xmark.circle") }
      Button { item.status = .inProgress } label: { Label("In Progress", systemImage: "hourglass") }
      Button { item.status = .onHold } label: { Label("On Hold", systemImage: "pause.circle") }
      Button { UIPasteboard.general.string = item.title } label: { Label("Copy Title", systemImage: "doc.on.doc") }
      Button { UIPasteboard.general.string = item.note } label: { Label("Copy Description", systemImage: "doc.on.doc") }
    }
  }
  
  private func statusActions(for item: Item) -> some View {
    Group {
      Button {
        item.status = item.status == .completed ? .notStarted : .completed
      } label: {
        Label(item.status == .completed ? "Not Started" : "Complete", systemImage: item.status == .completed ? "xmark.circle" : "checkmark.circle")
          .tint(item.status == .completed ? nil : .green)
      }
      if item.status != .inProgress {
        Button { item.status = .inProgress } label: { Label("In Progress", systemImage: "hourglass.circle.fill") }.tint(.blue)
      }
      if item.status != .onHold {
        Button { item.status = .onHold } label: { Label("On Hold", systemImage: "pause.circle") }.tint(.orange)
      }
    }
  }
}
