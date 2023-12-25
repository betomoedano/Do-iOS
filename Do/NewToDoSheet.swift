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
  
    var body: some View {
      Form {
        TextField("Title", text: $title)
        TextField("Description", text: $description)
        DatePicker("Date", selection: $date)
        Toggle("Repeats", isOn: $itRepeats)
        
        Picker(selection: $priority, label: Text("Priority")) {
          Text("None").tag(Priority.none)
          Text("Low").tag(Priority.low)
          Text("Medium").tag(Priority.medium)
          Text("High").tag(Priority.high)
        }
        .pickerStyle(.menu)
      }
    }
}

#Preview {
    NewToDoSheet()
}
