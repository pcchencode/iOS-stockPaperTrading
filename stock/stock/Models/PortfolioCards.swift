//
//  PortfolioCards.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/19.
//

import SwiftUI

struct PortfolioCards: View {
    var stockId: String
    var stockName: String
    var stockExchange: String
    var stockPercentage: Double = 8.7
    var stockQuantity: Int64
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis.circle")
                    .font(.system(size: 30))
                
                VStack(alignment: .leading) {
                    Text(stockName)
                        .bold()
                        .font(.title3)
                    Text("\(stockExchange)\(stockId)")
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                
                Spacer()
                
                Text("\(stockPercentage, specifier: "%.2f")%")
                    .bold()
                    .foregroundColor(stockPercentage >= 0 ? .green : .red)
            }
            Spacer()
            HStack {
                Text("庫存量: \(stockQuantity)")
                    .bold()
                    .font(.title)
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
        .padding(5)
        .frame(height: UIScreen.main.bounds.height/6)
        .frame(width: 250)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color("lightGray"))
        )
    }
}

struct PortfolioCards_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioCards(stockId: "Apple Inc", stockName: "AAPL", stockExchange: "sb", stockPercentage: 1.2, stockQuantity: 3)
    }
}
