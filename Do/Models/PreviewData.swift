import Foundation
import SwiftData

#if DEBUG
enum PreviewData {
    static var sampleItems: [Item] {
        [
            Item(
                title: "Complete Project Presentation",
                note: "Prepare slides and demo for the quarterly review meeting",
                status: .inProgress,
                tag: .work,
                date: Date.now,
                priority: .high
            ),
            Item(
                title: "Gym Session",
                note: "30 minutes cardio + strength training",
                status: .notStarted,
                tag: .personal,
                date: Date.now,
                priority: .medium
            ),
            Item(
                title: "Read Design Patterns Book",
                note: "Complete chapter 3 on behavioral patterns",
                status: .inProgress,
                tag: .study,
                date: Date.now.oneDayOut,
                priority: .medium
            ),
            Item(
                title: "Guitar Practice",
                note: "Practice new song chords for 45 minutes",
                status: .notStarted,
                tag: .hobby,
                date: Date.now.sevenDaysOut,
                priority: .low
            ),
            Item(
                title: "Team Dinner",
                note: "Restaurant reservation at 7 PM",
                status: .notStarted,
                tag: .social,
                date: Date.now.thirtyDaysOut,
                priority: .high
            )
        ]
    }
    
    static var sampleLists: [ListOfItems] {
        [
            ListOfItems(
                title: "Work Projects",
                about: "Current work-related tasks and deadlines",
                emoji: "💼",
                items: sampleItems.filter { $0.tag == .work }
            ),
            ListOfItems(
                title: "Personal Goals",
                about: "Personal development and lifestyle tasks",
                emoji: "🎯",
                items: sampleItems.filter { $0.tag == .personal }
            ),
            ListOfItems(
                title: "Study Plan",
                about: "Learning and educational goals",
                emoji: "📚",
                items: sampleItems.filter { $0.tag == .study }
            )
        ]
    }
    
    static func createDevData(modelContext: ModelContext) {
        // Only create data if the database is empty
        let itemDescriptor = FetchDescriptor<Item>()
        let listDescriptor = FetchDescriptor<ListOfItems>()
        
        guard (try? modelContext.fetch(itemDescriptor))?.isEmpty ?? true,
              (try? modelContext.fetch(listDescriptor))?.isEmpty ?? true else {
            return
        }
        
        // Add sample items
        sampleItems.forEach { modelContext.insert($0) }
        
        // Add sample lists
        sampleLists.forEach { modelContext.insert($0) }
    }
}

extension ModelContainer {
    static var preview: ModelContainer = {
        let schema = Schema([Item.self, ListOfItems.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            // Run on main actor since mainContext is main actor-isolated
            Task { @MainActor in
                let context = container.mainContext
                PreviewData.createDevData(modelContext: context)
            }
            return container
        } catch {
            fatalError("Could not create preview ModelContainer: \(error)")
        }
    }()
}
#endif
