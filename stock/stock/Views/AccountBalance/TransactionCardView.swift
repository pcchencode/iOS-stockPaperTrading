//
//  TransactionCardView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/30.
//

import SwiftUI
import Foundation

struct TransactionCardView: View {
    var stockName: String = "AAPL"
    var amount: Double = 94.87
    let colors: [Color] = [.yellow, .red, .purple, .green, .black]
    var randomColor: Color {
        colors.randomElement() ?? .yellow // 如果randomElement返回nil，使用黄色作为默认颜色
    }
    
    // 创建一个函数来获取并格式化当前日期时间
    func getCurrentFormattedDate() -> String {
        let now = Date()  // 获取当前日期和时间
        let formatter = DateFormatter()  // 创建一个日期格式化器
        //formatter.dateFormat = "YYYY/MM/dd HH:mm:ss"  // 设置格式化的格式
        formatter.dateFormat = "YYYY/MM/dd"  // 设置格式化的格式
        return formatter.string(from: now)  // 返回格式化后的日期字符串
    }
    
    var body: some View {

        VStack {
            HStack {
                
                Text(stockName.isEmpty ? "" : String(stockName.first!))
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(randomColor)
                    )
                
                VStack {
                    Text(stockName)
                        .bold()
                        .font(.title3)
                    Text("\(getCurrentFormattedDate())")
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                
                Spacer()
                
                Text("$\(String(amount))")
                    .bold()
                    .font(.title)
                
            }
            //Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical)
        .padding(5)
        .frame(height: UIScreen.main.bounds.height/8)
        .frame(width: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.white)
        )
    }
}

struct TransactionCardView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionCardView()
    }
}
