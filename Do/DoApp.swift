//
//  DoApp.swift
//  Do
//
//  Created by Alberto Moedano on 12/23/23.
//

import SwiftUI
import SwiftData
import WidgetKit

@main
struct DoApp: App {
  @Environment(\.scenePhase) var scenePhase
  
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Item.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
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
          }
        }
    }
    .modelContainer(sharedModelContainer)
  }
}
