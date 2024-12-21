//
//  CookieEmpireWidget.swift
//  CookieEmpireWidget
//
//  Created by I O N Groups Pvt Ltd on 2024-12-19.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CookieEntry {
        CookieEntry(date: Date(), cookies: 0, production: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (CookieEntry) -> ()) {
        let userDefaults = UserDefaults(suiteName: "group.CookieEmpireWidget")
        let cookies = userDefaults?.double(forKey: "cookies") ?? 0
        let production = userDefaults?.double(forKey: "production") ?? 0
        let entry = CookieEntry(date: Date(), cookies: cookies, production: production)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CookieEntry>) -> ()) {
        let userDefaults = UserDefaults(suiteName: "group.CookieEmpireWidget")
        let cookies = userDefaults?.double(forKey: "cookies") ?? 0
        let production = userDefaults?.double(forKey: "production") ?? 0
        
        let entry = CookieEntry(
            date: Date(),
            cookies: cookies,
            production: production
        )
        
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

}

struct CookieEntry: TimelineEntry {
    let date: Date
    let cookies: Double
    let production: Double
}

struct CookieEmpireWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color(red: 0.36, green: 0.20, blue: 0.09)
                .opacity(0.9)
            
            VStack(spacing: family == .systemSmall ? 8 : 12) {
                HStack {
                    // Resize the cookie image based on widget size
                    Image("cookie")
                        .resizable()
                        .scaledToFit()
                        .frame(width: family == .systemSmall ? 24 : (family == .systemMedium ? 50 : 60),
                               height: family == .systemSmall ? 24 : (family == .systemMedium ? 50 : 80))
                    
                    Text("\(Int(entry.cookies))")
                        .font(.system(size: family == .systemSmall ? 18 : (family == .systemMedium ? 24 : 30), weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text("\(String(format: "%.1f", entry.production))/s")
                    .font(.system(size: family == .systemSmall ? 12 : (family == .systemMedium ? 16 : 20)))
                    .foregroundColor(.white.opacity(0.8))
                
                Link(destination: URL(string: "cookieempire://tap")!) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.2))
                        
                        Image("cookie")
                            .resizable()
                            .frame(width: family == .systemSmall ? 74 : (family == .systemMedium ? 120 : 150), height: family == .systemSmall ? 74 : (family == .systemMedium ? 120 : 150))
                    }
                }
            }
            .padding(family == .systemSmall ? 20 : (family == .systemMedium ? 20 : 30))
            
        }
        .cornerRadius(10)
        .frame(
            width: family == .systemSmall ? 170 : (family == .systemMedium ? 345 : 345),
            height: family == .systemSmall ? 170 : (family == .systemMedium ? 100 : 367))
    }
}


struct CookieEmpireWidget: Widget {
    let kind: String = "CookieEmpireWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CookieEmpireWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Cookie Empire")
        .description("Track your cookie production!")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemSmall) {
    CookieEmpireWidget()
} timeline: {
    CookieEntry(date: .now, cookies: 1234, production: 5.6)
}

#Preview(as: .systemMedium) {
    CookieEmpireWidget()
} timeline: {
    CookieEntry(date: .now, cookies: 1234, production: 5.6)
}

#Preview(as: .systemLarge) {
    CookieEmpireWidget()
} timeline: {
    CookieEntry(date: .now, cookies: 1234, production: 5.6)
}

