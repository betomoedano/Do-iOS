//
//  DoWidgetLiveActivity.swift
//  DoWidget
//
//  Created by Alberto Moedano on 12/26/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DoWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct DoWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DoWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension DoWidgetAttributes {
    fileprivate static var preview: DoWidgetAttributes {
        DoWidgetAttributes(name: "World")
    }
}

extension DoWidgetAttributes.ContentState {
    fileprivate static var smiley: DoWidgetAttributes.ContentState {
        DoWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: DoWidgetAttributes.ContentState {
         DoWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: DoWidgetAttributes.preview) {
   DoWidgetLiveActivity()
} contentStates: {
    DoWidgetAttributes.ContentState.smiley
    DoWidgetAttributes.ContentState.starEyes
}
