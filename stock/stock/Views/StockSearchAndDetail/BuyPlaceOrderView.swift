//
//  BuyPlaceOrderView.swift
//  stock
//
//  Created by Po-Chu Chen on 5/22/24.
//

import SwiftUI

struct BuyPlaceOrderView: View {
    @State private var numberOfShares = ""
    @State private var stockPrice: Double = 87.00 // 示例股价，你可以动态获取
    @State private var stockName: String = "鴻海" // 示例股价，你可以动态获取
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Enter number of shares", text: $numberOfShares)
                .font(.system(size: 50))
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .foregroundColor(.red) // 设置文本颜色为红色
            
            Text("How many shares of \(stockName) would you like?")
                .font(.subheadline)
                .foregroundColor(.red) // 设置文本颜色为红色
            
            Divider()
                .padding(.vertical)
            
            Text("Your total cost will be")
                .font(.headline)
            
            Text("$\(calculateTotalCost(), specifier: "%.2f")")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            NumberPad(numberOfShares: $numberOfShares, buttonColor: .red)
                .padding(.horizontal, 20) // 增加水平填充
            
            Button(action: {
                // Place order action
            }) {
                Text("Place Order")
                    .bold()
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
    
    private func calculateTotalCost() -> Double {
        let shares = Double(numberOfShares) ?? 0
        return shares * stockPrice
    }
}

struct NumberPad: View {
    @Binding var numberOfShares: String
    var buttonColor: Color
    
    let buttons: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["", "0", "⌫"]
    ]
    
    var body: some View {
        VStack(spacing: 20) { // 增加垂直间距
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 20) { // 增加水平间距
                    ForEach(row, id: \.self) { button in
                        if button.isEmpty {
                            Spacer()
                                .frame(width: 100, height: 100) // 设置空白间隔的大小
                        } else {
                            Button(action: {
                                self.buttonTapped(button: button)
                            }) {
                                Text(button)
                                    .font(.largeTitle)
                                    .frame(width: 100, height: 100) // 增加按钮尺寸
                                    .background(buttonColor.opacity(0.1))
                                    .foregroundColor(buttonColor) // 设置按钮文本颜色为红色
                                    .cornerRadius(50) // 更新圆角半径以适应新的尺寸
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func buttonTapped(button: String) {
        switch button {
        case "⌫":
            if !numberOfShares.isEmpty {
                numberOfShares.removeLast()
            }
        default:
            numberOfShares.append(button)
        }
    }
}

struct BuyPlaceOrderView_Previews: PreviewProvider {
    static var previews: some View {
        BuyPlaceOrderView()
    }
}
