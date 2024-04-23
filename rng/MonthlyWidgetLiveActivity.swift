//
//  MonthlyWidgetLiveActivity.swift
//  MonthlyWidget
//
//  Created by Petros Gedekakis on 9/4/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MonthlyWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MonthlyWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MonthlyWidgetAttributes.self) { context in
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

extension MonthlyWidgetAttributes {
    fileprivate static var preview: MonthlyWidgetAttributes {
        MonthlyWidgetAttributes(name: "World")
    }
}

extension MonthlyWidgetAttributes.ContentState {
    fileprivate static var smiley: MonthlyWidgetAttributes.ContentState {
        MonthlyWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MonthlyWidgetAttributes.ContentState {
         MonthlyWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MonthlyWidgetAttributes.preview) {
   MonthlyWidgetLiveActivity()
} contentStates: {
    MonthlyWidgetAttributes.ContentState.smiley
    MonthlyWidgetAttributes.ContentState.starEyes
}
