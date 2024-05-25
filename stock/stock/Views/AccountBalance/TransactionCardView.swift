//
//  TransactionCardView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/30.
//

import SwiftUI
import Foundation

struct TransactionCardView: View {
    var transactionType: String = "AAPL"
    var amount: Double = 94.87
    
    // 根据交易类型设置颜色
    var transactionColor: Color {
        switch transactionType {
        case "Line":
            return .green
        case "Bank":
            return .blue
        case "ApplePay":
            return .black
        case "Withdraw":
            return .red
        case "Buy-Order":
            return .red
        case "Sell-Order":
            return .green
        default:
            return .gray
        }
    }
    
    // 创建一个函数来获取并格式化当前日期时间
    func getCurrentFormattedDate() -> String {
        let now = Date()  // 获取当前日期和时间
        let formatter = DateFormatter()  // 创建一个日期格式化器
        formatter.dateFormat = "YYYY/MM/dd"  // 设置格式化的格式
        return formatter.string(from: now)  // 返回格式化后的日期字符串
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(transactionType.isEmpty ? "" : String(transactionType.first!))
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(transactionColor)
                    )
                
                VStack(alignment: .leading) {
                    Text(transactionType)
                        .bold()
                        .font(.title3)
                    Text("\(getCurrentFormattedDate())")
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                
                Spacer()
                
                // 显示负数金额
                if transactionType == "Withdraw" {
                    Text(String(format: "$%.2f", -amount))
                        .bold()
                        .font(.title)
                } else if transactionType == "Buy-Order" {
                    Text(String(format: "$%.2f", -amount))
                        .bold()
                        .font(.title)
                } else if transactionType == "Sell-Order" {
                    Text(String(format: "$%.2f", amount))
                        .bold()
                        .font(.title)
                    
                } else {
                    Text(String(format: "$%.2f", amount))
                        .bold()
                        .font(.title)
                }
            }
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
