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
  @State private var date: Date = Date.now.addingTimeInterval(900) // Add 15 min
  @State private var priority: Priority = .none
  @State private var tag: Tag = .none
  @State private var status: Status = .notStarted
  @State private var scheduleAlert: Bool = true

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
              .onSubmit {
                if (!title.isEmpty) {
                  Task {
                    await saveDo(Item(
                      title: title,
                      note: description,
                      status: status,
                      tag: tag,
                      date: date,
                      priority: priority
                    ))
                  }
                }
              }
              .submitLabel(.done)
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
          
          Toggle(isOn: $scheduleAlert) {
            Text("Alert")
          }
          
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
                Text(tag.rawValue.capitalized).tag(tag)
              }
            }
          } footer: {
            Text("Set a category to easily sort tasks")
          }
        }
        .navigationTitle("New Task")
        .toolbar {
          #if os(iOS)
          ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
              Task {
                await saveDo(Item(
                  title: title,
                  note: description,
                  status: status,
                  tag: tag,
                  date: date,
                  priority: priority
                ))
              }
            }
            .disabled(title.isEmpty)
          }
          #endif
        }
      }
    }
  
  private func saveDo(_ item: Item) async {
    withAnimation {
      context.insert(item)
      print("Inserted item: \(item)")
      dismiss()
    }
    if scheduleAlert {
      await scheduleNotification(item)
    }
  }
  
  private func scheduleNotification(_ item: Item) async {
    let content = UNMutableNotificationContent()
    content.title = item.title
    content.body = item.note ?? ""
    // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute, .second], from: item.date)
    let uuidString = UUID().uuidString
    
    // Create trigger
    let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: components.hour, minute: components.minute, second: components.second), repeats: false)
    
    // Create request providing the trigger
    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
    
    do {
      try await UNUserNotificationCenter.current().add(request)
    } catch {
      // handle error
    }
  }
}

#Preview {
    NewToDoSheet()
}
