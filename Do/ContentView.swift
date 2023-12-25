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
                  NavigationLink {
                    VStack {
                      ItemView(item: item)
                    }
                  } label: {
                      Text(item.title)
                  }
              }
              .onDelete(perform: deleteItems)
          }
          
#if os(macOS)
          .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
          .toolbar {
#if os(iOS)
              ToolbarItem(placement: .navigationBarTrailing) {
                  EditButton()
              }
#endif
              ToolbarItem {
                  Button(action: showSheet) {
                      Label("Add Item", systemImage: "plus")
                  }
              }
          }
        .navigationTitle("Do")
      } detail: {
          Text("Select an item")
      }
      .sheet(isPresented: $showNewToDoSheet) {
          NewToDoSheet()
          .presentationDetents([.medium, .large])
      }
  }

  private func addItem() {
      withAnimation {
          let newItem = Item(title: "Hardcoded title")
          modelContext.insert(newItem)
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
