//
//  CustomAlert.swift
//  Do
//
//  Created by Alberto Moedano on 12/26/23.
//

import SwiftUI

struct CustomAlert: View {
    @Binding var textEntered: String
    @Binding var showingAlert: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
            VStack {
                Text("Custom Alert")
                    .font(.title)
                    .foregroundColor(.black)
                
                Divider()
                
                TextField("Enter text", text: $textEntered)
                    .padding(5)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                
                Divider()
                
                HStack {
                    Button("Dismiss") {
                        self.showingAlert.toggle()
                    }
                }
                .padding(30)
                .padding(.horizontal, 40)
            }
        }
        .frame(width: 300, height: 200)
    }
}

//struct ContentView: View {
//    @State private var textEntered = ""
//    @State private var showingAlert = false
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color.red.opacity(0.3)
//                    .edgesIgnoringSafeArea(.all)
//                
//                VStack(spacing: 20) {
//                    Button("Show Alert") {
//                        self.showingAlert.toggle()
//                        self.textEntered = ""
//                    }
//                    Text("\(textEntered)")
//                }
//                
//                CustomAlert(textEntered: $textEntered, showingAlert: $showingAlert)
//                    .opacity(showingAlert ? 1 : 0)
//                
//            }
//        .navigationBarTitle("Custom Alert")
//            .navigationBarItems(leading:
//                Button(action: {
//                    self.showingAlert.toggle()
//                }) {
//                    Image(systemName: "play.fill")
//            })
//        }
//        
//    }
//}

//#Preview {
//    CustomAlert()
//}
