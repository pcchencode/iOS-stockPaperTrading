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

//TestView是為了強制滿版，舊版Xcode很多設定都不適用
struct TestView : View {
//    let food = ["井上禾食","頂好紫琳","鼎泰豐","補時","一蘭拉麵"]
    let food = Food.examples
    @State private var selectedFood: Food?
    var body: some View {
        ZStack() {
            Color(.secondarySystemBackground).edgesIgnoringSafeArea(.all)
//            Color.yellow.edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                Group {
                    if selectedFood != .none {
                        Text(selectedFood!.image)
                            .font(.system(size: 200))
                            .minimumScaleFactor(0.1)
                            .lineLimit(1)
                    } else{
                        Image("dinner")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            
                    }
                }.frame(height: 350)


                Text("今天吃什麼？")
//                    .font(.title)
                    .font(.system(size: 50))
                    .bold()
                
                if selectedFood != .none {
                    HStack {
                        Text(selectedFood!.name)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.green)
                            .id(selectedFood!.name)
                            .transition(.asymmetric(insertion: .opacity, removal: .scale))
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    
                    Text("熱量 \(String(format: "%.0f", selectedFood!.calorie)) 大卡")
                    
                    HStack {
                        VStack(spacing: 12) {
                            Text("蛋白質")
                            Text(String(format: "%.0f", selectedFood!.protein)+" g")
                        }
                        
                        Divider().frame(width: 1).padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            Text("脂肪")
                            Text(String(format: "%.0f", selectedFood!.fat)+" g")
                        }
                        
                        Divider().frame(width: 1).padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            Text("碳水")
                            Text(String(format: "%.0f", selectedFood!.carb)+" g")
                        }
                    }
                    .font(.system(size: 24))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color(.systemBackground)))
 
                }
                
//                Spacer()

                Button() {
                    selectedFood = food.shuffled().filter { $0 != selectedFood}.first
                } label: {
                    Text(selectedFood == .none ?  "告訴我" : "換一個").frame(width: 200)
                }
                .font(.title)
                //.buttonStyle(.borderedProminent) //可能是因為舊版Xcode，這個指令沒有
                .foregroundColor(.white)
                .frame(height: 70)
                .background(Color.blue)
                .cornerRadius(35)
                .padding(.bottom, -15)
                                    
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
            .font(.title)
            .edgesIgnoringSafeArea(.all)
            .frame(
                  minWidth: 0,
                  maxWidth: .infinity,
                  minHeight: 0,
                  maxHeight: .infinity
            )
            .animation(.easeIn(duration: 1), value: selectedFood)        }
    }
}

extension TestView {
    init(selectedFood: Food) {
        _selectedFood = State(wrappedValue: selectedFood)
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
                .font(.largeTitle)
                .bold()
            
            if selectedFood != .none {
                Text(selectedFood ?? "")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.green)
                    .id(selectedFood)
                    .transition(.asymmetric(insertion: .opacity, removal: .scale))
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
        .edgesIgnoringSafeArea(.all)
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity
        )
        .background(Color(.secondarySystemBackground))
        .font(.title)
        .animation(.easeIn(duration: 1), value: selectedFood)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        TestView()
        TestView(selectedFood: Food.examples.first!)
//        ContentView()
            
            
    }
}
