//
//  ItemList.swift
//  Do
//
//  Created by Alberto Moedano on 12/26/23.
//

import Foundation
import SwiftData

@Model
final class ListOfItems: Identifiable, Hashable {
  var id = UUID()
  var title: String
  var about: String
  var emoji: String?
  var items: [Item]?
  
  init(id: UUID = UUID(), title: String, about: String, emoji: String? = nil, items: [Item]) {
    self.id = id
    self.title = title
    self.about = about
    self.emoji = emoji
    self.items = items
  }
}
