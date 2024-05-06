//
//  Tips.swift
//  Do
//
//  Created by Beto on 5/5/24.
//

import Foundation
import TipKit

struct AddToDoTip: Tip {
  var title: Text {
    Text ("Add your first Do")
  }
  
  var message: Text {
    Text("Once you create an item, it will appear here")
  }
  
  var image: Image? {
    Image(systemName: "circle.inset.filled")
  }
  
}
