//
//  mainWidget.swift
//  mainWidget
//
//  Created by Alberto Moedano on 3/15/24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
  @MainActor
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), items: getItems())
  }

  @MainActor
  func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: configuration, items: getItems())
  }
    
  @MainActor
  func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
      var entries: [SimpleEntry] = []
      
      // Determine the start and end time for entry generation
      let currentDate = Date()
      let endTime = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)! // For example, create entries for the next 1 minute
      
      // Generate entries every 5 seconds within the determined timeframe
      var nextDate = currentDate
      while nextDate <= endTime {
          let entry = SimpleEntry(date: nextDate, configuration: configuration, items: getItems())
          entries.append(entry)
          nextDate = Calendar.current.date(byAdding: .second, value: 1, to: nextDate)!
      }
      
      // Set the refresh policy
      let refreshDate = Calendar.current.date(byAdding: .second, value: 10, to: entries.last!.date)!
      return Timeline(entries: entries, policy: .after(refreshDate))
  }

  
  @MainActor
  private func getItems() -> [Item] {
    guard let modelContainer = try? ModelContainer(for: Item.self) else {
      return []
    }
    let descriptor = FetchDescriptor<Item>()
    let items = try? modelContainer.mainContext.fetch(descriptor)
    
    return items ?? []
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationAppIntent
  let items: [Item]
}

struct mainWidgetEntryView : View {
  @Query private var items: [Item]
  var entry: Provider.Entry
  
  var body: some View {
    VStack {
      Text("Today")
      Text(formatDate(entry.date))
      
      ForEach(entry.items) { item in
        Text(item.title)
      }
    }
  }
  
  // Function to format the date
  private func formatDate(_ date: Date) -> String {
      let formatter = DateFormatter()
      // Customize the date format
      formatter.dateFormat = "HH:mm:ss"
      return formatter.string(from: date)
  }
}

struct mainWidget: Widget {
  let kind: String = "mainWidget"
  
  var body: some WidgetConfiguration {
    AppIntentConfiguration(
      kind: kind,
      intent: ConfigurationAppIntent.self,
      provider: Provider()
    ) { entry in
      mainWidgetEntryView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
  }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    mainWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, items: [])
    SimpleEntry(date: .now, configuration: .starEyes, items: [])
}
