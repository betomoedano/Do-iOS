//
//  ContentView.swift
//  Do
//
//  Created by Alberto Moedano on 12/23/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var items: [Item]
  @State private var showNewToDoSheet: Bool = false

  var body: some View {
    NavigationSplitView {
      List {
        ForEach(items) { item in
          ItemRow(item: item)
            .swipeActions {
              Button(role: .destructive) {
                modelContext.delete(item)
              } label: {
                  Label("Delete", systemImage: "trash")
              }
            }
            .swipeActions(edge: .leading) {
              Button() {
                modelContext.delete(item)
              } label: {
                  Label("Complete", systemImage: "checkmark.circle")
              }
              .tint(.green)
              Button() {
                modelContext.delete(item)
              } label: {
                  Label("In Progress", systemImage: "hourglass.circle.fill")
              }
              .tint(.blue)
              Button() {
                modelContext.delete(item)
              } label: {
                  Label("On Hold", systemImage: "pause.circle")
              }
              .tint(.orange)
            }
        }
        .onDelete(perform: deleteItems)
        .listRowSeparator(.hidden)
      }
      .toolbar {
        ToolbarItem {
          Button(action: showSheet) {
            Label("Add Item", systemImage: "plus")
          }
        }
      }
    } detail: {
      Text("Select an item")
    }
    .sheet(isPresented: $showNewToDoSheet) {
      NewToDoSheet()
    }
  }

  private func showSheet() {
    showNewToDoSheet.toggle()
  }

  private func deleteItems(offsets: IndexSet) {
      withAnimation {
          for index in offsets {
            modelContext.delete(items[index])
          }
      }
  }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
