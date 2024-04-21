//
//  ContentView.swift
//  Do
//
//  Created by Alberto Moedano on 12/23/23.
//

import SwiftUI


struct ContentView: View {
  
  @State private var sortOrder = SortDescriptor(\Item.date)
  @State private var showNewToDoSheet: Bool = false
  
  var body: some View {
    NavigationSplitView {
      ItemListView(sort: sortOrder, order: sortOrder == SortDescriptor(\Item.date) ? "DESC" : "ASC")
        .toolbar {
          ToolbarItemGroup {
              Menu {
                  Button {
                      withAnimation {
                          sortOrder = SortDescriptor(\Item.timestamp)
                      }
                  } label: {
                      Label("Creation date", systemImage: "calendar")
                  }
                  Button {
                      withAnimation {
                          sortOrder = SortDescriptor(\Item.date)
                      }
                  } label: {
                      Label("Due date", systemImage: "calendar.badge.clock")
                  }
                  Button {
                      withAnimation {
                          sortOrder = SortDescriptor(\Item.title)
                      }
                  } label: {
                      Label("Alphabetically", systemImage: "textformat.abc")
                  }
              } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
              }
            Button {
              showNewToDoSheet.toggle()
            } label:{
              Label("Add Item", systemImage: "plus")
            }
          }
        }
//        .navigationTitle("Do")
    } detail: {
      Text("Select an item")
      Button {
        showNewToDoSheet.toggle()
      }label: {
        Label("Add Item", systemImage: "plus")
      }    }
    .sheet(isPresented: $showNewToDoSheet) {
      NewToDoSheet()
    }
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
}
