//
//  PerkeoWidget.swift
//  PerkeoWidget
//
//  Created by Alejandro Covarrubias on 21/12/25.
//

import WidgetKit
import SwiftUI
import CryptoKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {

    static var title: LocalizedStringResource = "Widget Configuration"
    static var description =
        IntentDescription("Configure how the Perkeo widget generates its code.")

}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), code: "PERKEO")
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), code: "PERKEO")
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let code: String
    
    init(date: Date, code : String){
        self.date = date
        self.code = code
    }
    
     init(date: Date) {
        self.date = date
        self.code = date.generateDailyCode()
    }
}

extension Font {
    static func customFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.custom("m6x11plus", size: size, relativeTo: .body)
            .weight(weight)
    }
    
    // Convenience methods for different font styles
    static let customHeadline = customFont(size: 20, weight: .bold)
    static let customTitle = customFont(size: 24, weight: .bold)
    static let customBody = customFont(size: 18)
    static let customCaption = customFont(size: 12)
}

extension Color {
    // Create a custom initializer for Color using a hex value
    init(hex: String) {
        
        let hex = hex.replacingOccurrences(of: "#", with: "")
        
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00ff00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000ff) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
    
    static let customBackground = Color(hex: "#1e1e1e")
    static let customRowBackground = Color(hex: "#4d4d4d")
}

struct PerkeoWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var fontSize : CGFloat {
        get {
            switch family {
            case .systemSmall:
                return 16
            case .systemMedium:
                return 20
            case .systemLarge:
                return 28
            default:
                return 20
            }
        }
    }

    var body: some View {
           VStack(spacing: 8) {
               Text("Today seed is")
                   .font(.customCaption)
                   .foregroundStyle(.secondary)

               Text(entry.code)
                   .font(.customTitle)
                   .tracking(2)
           }.containerBackground(Color.customBackground, for: .widget)
           .padding()
       }
}

struct PerkeoWidget: Widget {
    let kind: String = "PerkeoWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            PerkeoWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }.supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}


#Preview(as: .systemSmall) {
    PerkeoWidget()
} timeline: {
    SimpleEntry(date: .now)
    SimpleEntry(date: .now)
}


extension Date {
    func generateDailyCode() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateString = formatter.string(from: self)

        let hash = SHA256.hash(data: Data(dateString.utf8))
        let charset = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")

        return hash.prefix(8).map {
            charset[Int($0) % charset.count]
        }.map(String.init).joined()
    }
}
