//
//  DoApp.swift
//  Do
//
//  Created by Alberto Moedano on 12/23/23.
//

import SwiftUI
import SwiftData
import WidgetKit
import TipKit

@main
struct DoApp: App {
  @Environment(\.scenePhase) var scenePhase
  
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Item.self,
      ListOfItems.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
      let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
      return container
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
  init() {
    let center = UNUserNotificationCenter.current()
    Task {
      do {
        try await center.requestAuthorization(options: [.alert, .sound, .badge])
      } catch {
        // handle error
      }
    }
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .onChange(of: scenePhase) { oldScenePhase, newScenePhase in
          if newScenePhase == .background {
            WidgetCenter.shared.reloadAllTimelines()
            print("Reloaded all timelines.")
          }
        }
        .task {
          try? Tips.resetDatastore()
          try? Tips.configure([
            .displayFrequency(.immediate),
            .datastoreLocation(.applicationDefault)
            ])
        }
    }
    .modelContainer(sharedModelContainer)
  }
}
