//
//  NewToDoSheet.swift
//  Do
//
//  Created by Alberto Moedano on 12/25/23.
//

import SwiftUI

struct NewToDoSheet: View {
  @Environment(\.modelContext) private var context
  @Environment(\.dismiss) private var dismiss
  
  @State private var title: String = "dommy"
  @State private var description: String = ""
  @State private var date: Date = Date.now
  @State private var priority: Priority = .none
  @State private var tag: Tag = .none
  @State private var status: Status = .notStarted
  
  @FocusState private var isTitleFieldFocused: Bool
  @FocusState private var isDescriptionFieldFocused: Bool
//  Local state
  
    var body: some View {
      NavigationStack {
        Form {
          Section {
            TextField("Title", text: $title)
              .focused($isTitleFieldFocused)
              .listRowSeparator(.hidden)
              .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  self.isTitleFieldFocused = true
                }
              }
              .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                  if isTitleFieldFocused {
                    Button("", systemImage: "chevron.down") {
                      isDescriptionFieldFocused = true
                    }
                  } else {
                    Button("", systemImage: "chevron.up") {
                      isTitleFieldFocused = true
                    }
                  }
                  Spacer()
                  Button("", systemImage: "keyboard.chevron.compact.down") {
                    isDescriptionFieldFocused = false
                    isTitleFieldFocused = false
                  }
                }
              }
            TextField("Description", text: $description, axis: .vertical)
              .focused($isDescriptionFieldFocused)
              .frame(height: 80, alignment: .top)
          }
          
          
          DatePicker("Date", selection: $date)
            .listRowSeparator(.hidden)
          
          Picker(selection: $priority, label: Text("Priority")) {
            ForEach(Priority.allCases, id: \.self) { priority in
              Text(priority.rawValue.capitalized).tag(priority)
            }
          }
            .listRowSeparator(.hidden)
          
          Picker(selection: $status, label: Text("Status")) {
            ForEach(Status.allCases, id: \.self) { status in
              Text(status.rawValue).tag(status)
            }
          }
          
          Section {
            Picker(selection: $tag, label: Text("Category")) {
              ForEach(Tag.allCases, id: \.self) { tag in
                Text(tag.rawValue).tag(tag)
              }
            }
          } footer: {
            Text("Set a category to easily sort tasks")
          }
        }
        .navigationTitle("New Task")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
              saveDo(item: Item(
                title: title,
                note: description,
                date: date,
                priority: priority
              ))
            }
            .disabled(title.isEmpty)
          }
        }
      }
    }
  
  private func saveDo(item: Item) {
    withAnimation {
      context.insert(item)
      dismiss()
    }
  }
}

#Preview {
    NewToDoSheet()
}
