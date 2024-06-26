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


  init(sort: SortDescriptor<Item>, order: String) {
    _items = Query(sort: [sort])
    self.order = "ASC"
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(items[index])
      }
    }
  }
  
  var body: some View {
    if (items.isEmpty) {
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
        ForEach(Period.allCases) { period in
          let filteredItems = order == "ASC" ? items.filter { $0.period == period } : items.reversed().filter { $0.period == period }
          if !filteredItems.isEmpty {
            Section(content: {
              ForEach(order == "ASC" ? items : items.reversed()) { item in
                if item.period == period {
                  ItemRow(item: item)
                    .swipeActions {
                      Button(role: .destructive) {
                        withAnimation {
                          modelContext.delete(item)
                        }
                      } label: {
                        Label("Delete", systemImage: "trash")
                      }
                    }
                    .contextMenu(ContextMenu(menuItems: {
                      //                  Button {
                      //                  } label: {
                      //                    Label("Add to Favorites", systemImage: "heart")
                      //                  }
                      Button {
                        item.status = Status.completed
                      } label: {
                        Label("Complete", systemImage: "checkmark.circle")
                      }
                      Button {
                        item.status = Status.notStarted
                      } label: {
                        Label("Not Started", systemImage: "xmark.circle")
                      }
                      Button {
                        item.status = Status.inProgress
                      } label: {
                        Label("In Progress", systemImage: "hourglass")
                      }
                      Button {
                        item.status = Status.onHold
                      } label: {
                        Label("On Hold", systemImage: "pause.circle")
                      }
                      //                  Button {
                      //                  } label: {
                      //                    Label("Edit", systemImage: "pencil")
                      //                  }
                      Button {
                        let pasteboard = UIPasteboard.general
                        pasteboard.string = item.title
                      } label: {
                        Label("Copy Title", systemImage: "doc.on.doc")
                      }
                      Button {
                        let pasteboard = UIPasteboard.general
                        pasteboard.string = item.note
                      } label: {
                        Label("Copy Description", systemImage: "doc.on.doc")
                      }
                    }))
                    .swipeActions(edge: .leading) {
                      Button() {
                        if (item.status == .completed) {
                          item.status = Status.notStarted
                        } else {
                          item.status = Status.completed
                        }
                      } label: {
                        if (item.status == .completed) {
                          Label("Not Started", systemImage: "xmark.circle")
                        } else {
                          Label("Complete", systemImage: "checkmark.circle")
                            .tint(.green)
                        }
                      }
                      if (item.status != .inProgress) {
                        Button() {
                          item.status = Status.inProgress
                        } label: {
                          Label("In Progress", systemImage: "hourglass.circle.fill")
                        }
                        .tint(.blue)
                      }
                      if (item.status != .onHold) {
                        Button() {
                          item.status = Status.onHold
                        } label: {
                          Label("On Hold", systemImage: "pause.circle")
                        }
                        .tint(.orange)
                      }
                    }
                }
              }
              .onDelete(perform: deleteItems)
              .listRowSeparator(.hidden)
            }, header: {
              Text(period.name.lowercased() == "today" ? "TODAY " + Date.now.formatted(date: .long, time: .omitted) : period.name)
            })
          }
        }
      }
    }
  }}
