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
    
    return SimpleEntry(date: Date(), configuration: configuration, items: generateDemoData())
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
      nextDate = Calendar.current.date(byAdding: .second, value: 10, to: nextDate)!
    }
    
    // Set the refresh policy
    let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
    print(refreshDate, "refreshed!")
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
    VStack(alignment: .leading) {
      HStack(alignment: .top) {
        VStack(alignment: .leading ) {
          Text("Today")
            .font(.caption)
          Text(formattedDateWithoutYear(Date.now))
            .font(.title2)
            .bold()
            .fontDesign(.rounded)
        }
        Spacer()
        Image("Logo")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 40)
      }
      ForEach(entry.items) { item in
        HStack(alignment: .center) {
          statusCircle(for: item)
          Text(item.title)
            .font(.caption)
//          Spacer()
//          Text("\(item.date.formatted(date: .omitted, time: .shortened))")
//            .font(.custom("test", fixedSize: 10))
//            .foregroundStyle(.secondary)
        }
      }
      Spacer()
    }
  }
  
  func statusCircle(for item: Item) -> some View {
      Circle()
        .fill(colorForStatus(item.status))
        .frame(width: 15)
  }

  private func colorForStatus(_ status: Status) -> Color {
      switch status {
      case .notStarted:
          return .gray
      case .inProgress:
          return .blue
      case .completed:
          return .green
      case .onHold:
          return .orange
      }
  }
  
  func formattedDateWithoutYear(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E d" // "MMM" for the abbreviated month, "d" for the day of the month
    return dateFormatter.string(from: date)
  }
}


struct mainWidget: Widget {
  
  var body: some WidgetConfiguration {
    AppIntentConfiguration(
      kind: "mainWidget",
      intent: ConfigurationAppIntent.self,
      provider: Provider()
    ) { entry in
      mainWidgetEntryView(entry: entry)
        .containerBackground(.background, for: .widget)
    }
    .configurationDisplayName(Text("Today's Activities"))
    .description(Text("Shows an overview of your day activities."))
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
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

func generateDemoData() -> [Item] {
  let task1 = Item(title: "Morning Jog", note: "30 minutes around the park", status: .completed, tag: .personal, date: Date(), priority: .high)
  let task2 = Item(title: "Read Book", note: "Finish reading 'The Alchemist'", status: .inProgress, tag: .personal, date: Date(), priority: .medium)
  let task3 = Item(title: "Weekly Planning", note: "Plan out the week's tasks and goals", status: .notStarted, tag: .work, date: Date(), priority: .high)
  let task4 = Item(title: "Grocery Shopping", note: "Remember to buy milk and eggs", status: .notStarted, tag: .personal, date: Date(), priority: .low)
  let task5 = Item(title: "Study Session", note: "Focus on Java fundamentals", status: .inProgress, tag: .personal, date: Date(), priority: .medium)
  
  return[task1, task2, task3, task4, task5];
}

#Preview(as: .systemSmall) {
    mainWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, items: [])
}
