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
  
  @State private var title: String = ""
  @State private var description: String = ""
  @State private var date: Date = Date.now
  @State private var itRepeats: Bool = false
  @State private var priority: Priority = .none
  
//  Local state
  @State private var toggleDate: Bool = false
  @State private var toggleTime: Bool = false
  
    var body: some View {
      NavigationStack {
        Form {
          Section {
            TextField("Title", text: $title)
              .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                  Button("Save") {
                    print("Pressed!")
                  }
                }
              }
            TextField("Description", text: $description, axis: .vertical)
              .frame(height: 80, alignment: .top)
          }
          
          Section {
            Image(systemName:"calendar")
              .imageScale(.medium)
              .background(in: RoundedRectangle(cornerRadius: 20).inset(by: -5))
              .backgroundStyle(.blue.gradient)
              .foregroundStyle(
                .white.shadow(.drop(radius: 1, y: 1.5))
              )
            Toggle("Date", systemImage: "calendar.badge.plus", isOn: $toggleDate)
            DatePicker(
              "Date",
              selection: $date,
              displayedComponents: .date
            )
            Toggle("Time", systemImage: "clock.fill", isOn: $toggleTime)
            if toggleTime {
                DatePicker(
                  "",
                  selection: $date,
                  displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(.wheel)
            }
            Toggle("Repeats", isOn: $itRepeats)
          }
          
          Picker(selection: $priority, label: Text("Priority")) {
            Text("None").tag(Priority.none)
            Text("Low").tag(Priority.low)
            Text("Medium").tag(Priority.medium)
            Text("High").tag(Priority.high)
          }
          .pickerStyle(.menu)
        }
        .navigationTitle("New Do")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
              saveDo(item: Item(
                title: title,
                note: description,
                date: date,
                itRepeats: itRepeats,
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
