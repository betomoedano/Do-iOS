//
//  AppIntent.swift
//  mainWidget
//
//  Created by Alberto Moedano on 3/15/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Today's Activities"
    static var description = IntentDescription("Shows an overview of your day activities.")

    // An example configurable parameter.
//    @Parameter(title: "Activities for", default: "Today")
//    var favoriteEmoji: String
}
