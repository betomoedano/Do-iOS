//
//  ContentView.swift
//  Do
//
//  Created by Alberto Moedano on 12/23/23.
//

import SwiftUI
import TipKit

struct ContentView: View {
  
  @State private var sortOrder = SortDescriptor(\Item.date)
  @State private var showNewToDoSheet: Bool = false
  @State private var isSingleList: Bool = false
  
  var body: some View {
    NavigationSplitView {
      ItemListView(sort: sortOrder, order: sortOrder == SortDescriptor(\Item.date) ? "DESC" : "ASC", isSingleList: isSingleList)
        .toolbar {
            ToolbarItemGroup {
              Menu {
                Button {
                  withAnimation {
                    isSingleList.toggle()
                  }
                } label: {
                  Label(isSingleList ? "Grouped by Period" : "Single list", systemImage: isSingleList ? "tray.full" : "list.bullet")
                }
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
//                addToDoTip.invalidate(reason: .actionPerformed)
              } label:{
                Label("Add Item", systemImage: "plus")
              }
              
            }
          }
//        .popoverTip(addToDoTip, arrowEdge: .bottom, action: {_ in
//          print("hello")
//        })
    } detail: {
      Text("Select an item")
      Button {
        showNewToDoSheet.toggle()
      }label: {
        Label("Add Item", systemImage: "plus")
      }
    }
    .sheet(isPresented: $showNewToDoSheet) {
      NewToDoSheet()
    }
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
}
