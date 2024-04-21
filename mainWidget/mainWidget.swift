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
    let items = getItems()
    return SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), items: items, todayStats: getStats())
  }

  @MainActor
  func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
    return SimpleEntry(date: Date(), configuration: configuration, items: generateDemoData(), todayStats: getStats())
  }
    
  @MainActor
  func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
    let items = getItems()
    
    // Determine the start and end time for entry generation
    let currentDate = Date()
    
    // Create a date that's 5 minutes in the future.
    let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
    
    let entry: SimpleEntry = SimpleEntry(date: nextUpdateDate, configuration: configuration, items: items, todayStats: getStats())
    
    print("Current Date: ", currentDate, "Next Update: ", nextUpdateDate)
    
    return Timeline(entries: [entry], policy: .after(nextUpdateDate))
  }

  
  @MainActor
  private func getItems() -> [Item] {
    guard let modelContainer = try? ModelContainer(for: Item.self) else {
      return []
    }
    let descriptor = FetchDescriptor<Item>()
    let items = try? modelContainer.mainContext.fetch(descriptor)
    
    // Filter tasks for today that are not completed
    let taskForToday = items?.filter { $0.period == .today && $0.status != .completed } ?? []

//    let taskForToday = items?.filter { $0.period == .today } ?? []
//    let taskForNextSevenDays = items?.filter { $0.period == .nextSevenDays } ?? []

    return taskForToday
  }
  
  @MainActor
  private func getStats() -> TodayStats {
    guard let modelContainer = try? ModelContainer(for: Item.self) else {
      return TodayStats(notStarted: 0, completed: 0, inProgress: 0)
    }
    let descriptor = FetchDescriptor<Item>()
    let items = try? modelContainer.mainContext.fetch(descriptor)
    
    // Filter tasks for today that are not completed
    let notCompleted = items?.filter { $0.period == .today && $0.status == .notStarted }.count ?? 0
    let completed = items?.filter { $0.period == .today && $0.status == .completed }.count ?? 0
    let inProgress = items?.filter { $0.period == .today && $0.status == .inProgress }.count ?? 0

    return TodayStats(notStarted: notCompleted, completed: completed, inProgress: inProgress)
  }
}


struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationAppIntent
  let items: [Item]
  let todayStats: TodayStats
}

struct TodayStats {
  let notStarted: Int
  let completed: Int
  let inProgress: Int
}

struct mainWidgetEntryView : View {
  @Environment(\.widgetFamily) var widgetFamily
  var entry: Provider.Entry
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .top) {
        VStack(alignment: .leading ) {
          Text("Today")
            .font(.caption)
          Text(formattedDateWithoutYear(Date.now))
            .font(.title)
            .minimumScaleFactor(0.8)
            .bold()
            .fontDesign(.rounded)
        }
        Spacer()
        //        Image("Logo")
        //          .resizable()
        //          .aspectRatio(contentMode: .fit)
        //          .frame(height: 40)
        VStack(alignment: .leading, spacing: 0) {
          statsItem(total: entry.todayStats.completed, color: .green)
          statsItem(total: entry.todayStats.inProgress, color: .blue)
          statsItem(total: entry.todayStats.notStarted, color: .gray)
        }
      }
      
      if (entry.items.isEmpty) {
        VStack {
          Spacer()
          HStack {
            Spacer()
            if (widgetFamily == .systemSmall) {
              Text("Tap to add a task!")
                .font(.caption)
                .foregroundStyle(.secondary)
            } else {
              Text("No tasks yet. Tap to add a task!")
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer()
          }
          Spacer()
        }
      } else {
        ForEach(entry.items.prefix(3)) { item in
          HStack(alignment: .center) {
            statusCircle(for: item)
            Text(item.title)
              .font(.caption)
              .strikethrough(item.status == .completed, color: .secondary)
              .lineLimit(1)
            Spacer()
            Text("\(item.date.formatted(date: .omitted, time: .shortened))")
              .font(.custom("test", fixedSize: 10))
              .foregroundStyle(.secondary)
          }
        }
        Spacer()
      }
    }
    .transition(.push(from: .bottom))
  }
  
  func statsItem(total: Int, color: Color) -> some View {
    HStack(alignment: .center, spacing: 6) {
      Circle()
        .fill(color)
        .frame(width: 10)
      Text(total.description)
        .contentTransition(.numericText(value: Double(total)))
        .minimumScaleFactor(0.8)
        .fontDesign(.rounded)
        .font(.caption2)
        .bold()
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
//        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "🤩"
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
  SimpleEntry(date: .now, configuration: .smiley, items: [], todayStats: TodayStats(notStarted: 5, completed: 2, inProgress: 1))
}
