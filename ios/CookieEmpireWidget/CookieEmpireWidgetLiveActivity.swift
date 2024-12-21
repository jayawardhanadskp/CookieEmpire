//
//  CookieEmpireWidgetLiveActivity.swift
//  CookieEmpireWidget
//
//  Created by I O N Groups Pvt Ltd on 2024-12-19.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CookieEmpireWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct CookieEmpireWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CookieEmpireWidgetAttributes.self) { context in
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

extension CookieEmpireWidgetAttributes {
    fileprivate static var preview: CookieEmpireWidgetAttributes {
        CookieEmpireWidgetAttributes(name: "World")
    }
}

extension CookieEmpireWidgetAttributes.ContentState {
    fileprivate static var smiley: CookieEmpireWidgetAttributes.ContentState {
        CookieEmpireWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: CookieEmpireWidgetAttributes.ContentState {
         CookieEmpireWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: CookieEmpireWidgetAttributes.preview) {
   CookieEmpireWidgetLiveActivity()
} contentStates: {
    CookieEmpireWidgetAttributes.ContentState.smiley
    CookieEmpireWidgetAttributes.ContentState.starEyes
}
