//
//  StockCardView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/19.
//

import SwiftUI

struct StockCardView: View {
    var stockName: String = "AAPL"
    var stockId: String = "2330"
    var stockExchange: String = "TW"
    
    @State private var currentPrice: Double = 0.0
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "appletv.fill")
                    .font(.system(size: 50))
                
                VStack {
                    Text(stockName)
                        .bold()
                        .font(.title3)
                    Text("\(stockExchange)\(stockId) Inc")
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                
                Spacer()
                
                Text("1.2%")
                    .bold()
                    .foregroundColor(.green)
            }
            Spacer()
            HStack {
                Text("$\(currentPrice, specifier: "%.2f")")
                    .bold()
                    .font(.title)
                Spacer()
                Text("Graph")
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
        .padding(5)
        .frame(height: UIScreen.main.bounds.height / 6)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color("lightGray"))
        )
        .onAppear {
            fetchData()
        }
    }
    
    private func fetchData() {
        Task {
            do {
                let stockInfoList = try await Webservice().getSinaStockInfo(stockExchange: stockExchange, stockId: stockId)
                print("Fetched stock info list: \(stockInfoList)") // Debug output
                if let stockInfo = stockInfoList.first {
                    self.currentPrice = stockInfo.currentPrice
                } else {
                    print("Stock info list is empty") // Debug output
                }
            } catch {
                print("Failed to fetch stock information: \(error)")
            }
        }
    }
}

struct StockCardView_Previews: PreviewProvider {
    static var previews: some View {
//        StockCardView()
        StockCardView(stockName: "雷曼光电", stockId: "300162", stockExchange: "sz")
    }
}
