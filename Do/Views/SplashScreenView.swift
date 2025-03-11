//
//  SplashScreenView.swift
//  Do
//
//  Created by beto on 3/10/25.
//

import SwiftUI
import SwiftData
import WidgetKit
import TipKit


struct SplashScreenView: View {
  @State private var isActive = false
  @State private var scale: CGFloat = 0.8
  @State private var opacity: Double = 0.5
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
  var body: some View {
    if isActive {
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
        .modelContainer(sharedModelContainer)
    } else {
      ZStack {
        Color(.systemBackground)
          .ignoresSafeArea()
        
        VStack(spacing: 16) {
          Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 100, weight: .bold))
            .foregroundStyle(.green)
            .scaleEffect(scale)
            .opacity(opacity)
            .animation(.easeInOut(duration: 1.2), value: scale)
            .onAppear {
              withAnimation {
                scale = 1.1
                opacity = 1
              }
            }
          
          Text("Do")
            .font(.largeTitle)
            .fontWeight(.bold)
          
          Text("Simple Task Manager")
            .font(.title3)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
        }
      }
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          self.isActive = true
        }
      }
    }
  }
}

#Preview {
  SplashScreenView()
}
