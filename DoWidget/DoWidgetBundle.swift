//
//  DoWidgetBundle.swift
//  DoWidget
//
//  Created by Alberto Moedano on 12/26/23.
//

import WidgetKit
import SwiftUI

@main
struct DoWidgetBundle: WidgetBundle {
    var body: some Widget {
        DoWidget()
        DoWidgetLiveActivity()
    }
}
