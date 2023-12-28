//
//  ItemRow.swift
//  Do
//
//  Created by Alberto Moedano on 12/27/23.
//

import SwiftUI

struct ItemRow: View {
  var item: Item
  
  var body: some View {
    HStack {
      Text(item.title)
    }
  }
}

#Preview {
  ItemRow(
    item: Item.init(
      title: "Camping Trip",
      note: "This is a description for a camping trip ficticious trip that does not exists",
      status: Status.completed,
      tag: Tag.hobby,
      date: Date.now,
      priority: Priority.high,
      timestamp: Date.distantFuture
    )
  )
}
