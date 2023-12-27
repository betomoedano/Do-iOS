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
  @State private var multiSelection = Set<UUID>()

  var body: some View {
      NavigationSplitView {
        List(items, selection: $multiSelection) {
          Text($0.title)
        }
        .navigationTitle("Do")
        .toolbar {
          EditButton()
          Button(action: showSheet) {
            Label("Add Item", systemImage: "plus")
          }
        }
        Text("\(multiSelection.count) selections")
//          List {
//              ForEach(items) { item in
//                  NavigationLink {
//                    VStack {
//                      ItemView(item: item)
//                    }
//                  } label: {
//                      Text(item.title)
//                  }
//              }
//              .onDelete(perform: deleteItems)
//          }
          
//          .toolbar {
//              ToolbarItem(placement: .navigationBarTrailing) {
//                  EditButton()
//              }
//              ToolbarItem {
//                  Button(action: showSheet) {
//                      Label("Add Item", systemImage: "plus")
//                  }
//              }
//          }
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
