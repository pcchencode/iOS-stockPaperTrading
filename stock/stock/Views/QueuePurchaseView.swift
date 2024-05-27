//
//  QueuePurchaseView.swift
//  stock
//
//  Created by Po-Chu Chen on 5/27/24.
//

import SwiftUI

struct QueuePurchaseView: View {
    @State private var selectedStock: String = ""
    @State private var numberOfShares: String = ""
    @State private var queueList: [(stock: String, quantity: Int)] = []
    @State private var bounce: Bool = false
    
    var body: some View {
        VStack {
            // 已排隊的股票列表或佔位符
            ScrollView {
                VStack {
                    if queueList.isEmpty {
                        HStack {
                            Text("Queue your first stock")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding()
                                .scaleEffect(bounce ? 1.05 : 1.0)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever(autoreverses: true)
                                )
                                .onAppear {
                                    bounce = true
                                }
                            
                            Spacer()
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding([.horizontal, .top])
                    } else {
                        ForEach(queueList, id: \.self.stock) { item in
                            HStack {
                                Text(item.stock)
                                    .font(.headline)
                                    .padding()
                                
                                Spacer()
                                
                                Text("\(item.quantity) shares")
                                    .padding()
                                
                                Button(action: {
                                    removeFromQueue(stock: item.stock)
                                }) {
                                    Text("Cancel")
                                        .foregroundColor(.red)
                                }
                                .padding()
                            }
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding([.horizontal, .top])
                        }
                    }
                }
            }
            
            //Divider()
            
            // 顏色和樣式保持一致
            VStack {
                Text("Queue Purchase")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                TextField("Enter stock symbol", text: $selectedStock)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.horizontal, .top])
                Spacer().frame(height: 20) // 添加間距
                TextField("Enter number of shares", text: $numberOfShares)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding([.horizontal, .bottom])
                
                Button(action: {
                    addToQueue()
                }) {
                    Text("Add to Queue")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(
                                    LinearGradient(colors: [Color("Gradient1"), Color("Gradient2"), Color("Gradient3")], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                        }
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .frame(height: UIScreen.main.bounds.height / 2.5) // 調整卡片的大小
            .background(Color("lightGray"))
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.horizontal)
            .padding(.bottom)
            
        }
    }
    
    private func addToQueue() {
        if let quantity = Int(numberOfShares), !selectedStock.isEmpty {
            queueList.append((stock: selectedStock, quantity: quantity))
            selectedStock = ""
            numberOfShares = ""
        }
    }
    
    private func removeFromQueue(stock: String) {
        queueList.removeAll { $0.stock == stock }
    }
}

struct QueuePurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        QueuePurchaseView()
    }
}
