//
//  ContentView.swift
//  ProjectTest
//
//  Created by PO CHU CHEN on 2024/3/28.
//

import SwiftUI

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

struct ContentView: View {
    let food = ["井上禾食","頂好紫琳","鼎泰豐","補時","一蘭拉麵"]
    @State private var selectedFood: String?
    
    var body: some View {
        VStack(spacing: 30) {
            Image("dinner")
                .resizable()
                .aspectRatio(contentMode: .fit)

            Text("今天吃什麼？")
                .font(.title)
                .bold()
            
            if selectedFood != .none {
                Text(selectedFood ?? "")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.green)
            }

            Button() {
                selectedFood = food.shuffled().filter { $0 != selectedFood}.first
            } label: {
                Text(selectedFood == .none ?  "告訴我" : "換一個").frame(width: 200)
            }
            .font(.title)
            //.buttonStyle(.borderedProminent) //可能是因為舊版Xcode，這個指令沒有
            .foregroundColor(.white)
            .frame(height: 80)
            .background(Color.blue)
            .cornerRadius(35)
            .padding(.bottom, -15)
                    
//            Button("重置") {
//                selectedFood = .none
//            }
//            .font(.title)
            
            Button() {
                selectedFood = .none
            } label: {
                Text("重置").frame(width:200)
            }
            .font(.title)
            .foregroundColor(.blue)
            .frame(height: 50)
            .background(Color.gray.brightness(0.3))
            .cornerRadius(40)
        }
        .padding()
        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: selectedFood)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
