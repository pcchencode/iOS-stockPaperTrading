//
//  SellPlaceOrderView.swift
//  stock
//
//  Created by Po-Chu Chen on 5/23/24.
//

import SwiftUI

struct SellPlaceOrderView: View {
    @State private var numberOfShares = ""
    @State private var stockPrice: Double = 0.00
    @State private var orderPlaced = false
    @State private var portfolioQuantity: Int64 = 0
    
    var stockID: String
    var stockName: String
    var stockExchange: String
    
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: PortfolioItem.entity(), sortDescriptors: [])
    private var portfolioItems: FetchedResults<PortfolioItem>
    @FetchRequest(entity: Balance.entity(), sortDescriptors: [])
    private var balances: FetchedResults<Balance>
    
    var body: some View {
        VStack {
            VStack {
                Spacer().frame(height: 50)
                // 拉桿視圖
                VStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .frame(width: 40, height: 6)
                        .foregroundColor(.gray)
                        .padding(.top, 1)
                        .padding(.bottom, 12)
                }
                Spacer().frame(height: 20)
            }
            .fixedSize(horizontal: false, vertical: true)

            Spacer()
            
            if orderPlaced {
                // 显示下单成功的视图
                VStack {
                    Image(systemName: "checkmark.seal.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green)
                    Text("Order Placed")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.green)
                }
            } else {
                VStack {
                    Text("You have \(portfolioQuantity) shares of \(stockName)")
                        .font(.subheadline)
                        .foregroundColor(.green)
                        .padding(.bottom, 10)

                    TextField("Enter number of shares", text: $numberOfShares)
                        .font(.system(size: 50))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.green)
                    
                    Text("How many shares of \(stockName) would you like to sell?")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    
                    Divider()
                        .padding(.vertical)
                    
                    Text("Your total value will be")
                        .font(.headline)
                    
                    Text("$\(calculateTotalValue(), specifier: "%.2f")")
                        .font(.largeTitle)
                        .bold()
                    
                    if !numberOfShares.isEmpty {
                        if Int64(numberOfShares) ?? 0 > portfolioQuantity {
                            Text("You don't have enough shares")
                                .foregroundColor(.red)
                        }
                    }
                    
                    Spacer()
                    
                    NumberPad(numberOfShares: $numberOfShares, buttonColor: .green)
                        .padding(.horizontal, 20)
                    
                    Button(action: {
                        placeOrder()
                    }) {
                        Text("Place Order")
                            .bold()
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isPortfolioSufficient() ? Color.green : Color.green.opacity(0.3))
                            .cornerRadius(10)
                    }
                    .padding()
                    .disabled(!isPortfolioSufficient())
                }
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            fetchStockPrice()
            fetchPortfolioQuantity()
        }
    }
    
    private func fetchStockPrice() {
        // Replace this with the actual API call to fetch the stock price
        Task {
            do {
                let stockInfoList = try await Webservice().getSinaStockInfo(stockExchange: stockExchange, stockId: stockID)
                if let stockInfo = stockInfoList.first {
                    stockPrice = stockInfo.currentPrice
                } else {
                    print("No stock information available.")
                }
            } catch {
                print("Failed to fetch stock information: \(error)")
            }
        }
    }
    
    private func fetchPortfolioQuantity() {
        // Fetch the quantity of the stock from PortfolioItem
        if let item = portfolioItems.first(where: { $0.stockId == stockID && $0.stockExchange == stockExchange }) {
            portfolioQuantity = item.quantity
        } else {
            portfolioQuantity = 0
        }
    }
    
    private func calculateTotalValue() -> Double {
        let shares = Double(numberOfShares) ?? 0
        return shares * stockPrice
    }
    
    private func isPortfolioSufficient() -> Bool {
        let shares = Int64(numberOfShares) ?? 0
        return shares <= portfolioQuantity && shares > 0
    }
    
    private func placeOrder() {
        let sharesToSell = Int64(numberOfShares) ?? 0
        let totalValue = calculateTotalValue()
        
        // Create a new transaction
        let transaction = Transaction(context: viewContext)
        transaction.id = UUID()
        transaction.amount = totalValue
        transaction.date = Date()
        transaction.type = "Sell-Order"
        
        // Update the balance
        if let balanceEntity = balances.first {
            balanceEntity.balance += totalValue
        }
        
        // Update or remove PortfolioItem
        if let item = portfolioItems.first(where: { $0.stockId == stockID && $0.stockExchange == stockExchange }) {
            item.quantity -= sharesToSell
            if item.quantity <= 0 {
                viewContext.delete(item)
            }
        }
        
        // Save the context
        do {
            try viewContext.save()
            orderPlaced = true
        } catch {
            print("Failed to save transaction: \(error.localizedDescription)")
        }
        
        // Order placed successfully
        withAnimation {
            orderPlaced = true
        }
    }
}

struct SellPlaceOrderView_Previews: PreviewProvider {
    static var previews: some View {
        SellPlaceOrderView(stockID: "300162", stockName: "雷曼光电", stockExchange: "sz")
    }
}
