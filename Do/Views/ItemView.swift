//
//  ItemView.swift
//  Do
//
//  Created by Alberto Moedano on 12/23/23.
//

import SwiftUI

struct ItemView: View {
  var item: Item
    var body: some View {
      NavigationStack {
        if let note = item.note {
          Text(note)
        }
        Text(item.date, style: .date)
        Text(item.itRepeats ? "Repeats" : "One time")
        Text("Priority \(String(describing: item.priority))")
        .navigationTitle(item.title)
      }
    }
}

#Preview {
  ItemView(item: Item.init(title: "hello", note: "This is a description haha, lol call me maybe, this is a test lorem ipsum dolor test chat gpt hello esting"))
}
