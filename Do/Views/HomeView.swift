//
//  HomeView.swift
//  Do
//
//  Created by Alberto Moedano on 12/25/23.
//

import SwiftUI

struct HomeView: View {
  @State private var expandMessage: Bool = false
    var body: some View {
      Text("Code with Beto LLC!")
        .font(expandMessage ? .largeTitle.weight(.heavy) : .body)
        .foregroundStyle(.teal.shadow(.drop(radius: 1, y: 1.5)))
        .onTapGesture {
          withAnimation {
            expandMessage.toggle()
          }
        }
      HStack {
          Image(systemName: "triangle.fill")
          Text("Hello, world!")
          .font(.largeTitle.weight(.heavy))
          RoundedRectangle(cornerRadius: 5)
              .frame(width: 40, height: 20)
      }
      .foregroundStyle(.linearGradient(
          colors: [.yellow, .blue],
          startPoint: .top,
          endPoint: .bottom
      ).shadow(.drop(radius: 1, y: 2)))
      
      Text("Code with Beto LLC!")
        .font(.largeTitle.weight(.heavy))
        .fontDesign(.rounded)
    }
}

#Preview {
    HomeView()
}
