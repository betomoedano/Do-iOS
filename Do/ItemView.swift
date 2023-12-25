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
      Text(item.title)
    }
}

#Preview {
  ItemView(item: Item.init(title: "hello"))
}
