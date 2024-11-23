//
//  BuyPlaceOrderView.swift
//  stock
//
//  Created by Po-Chu Chen on 5/22/24.
//

import SwiftUI
import CoreData

struct BuyPlaceOrderView: View {
    @State private var numberOfShares = ""
    @State private var stockPrice: Double = 0.00
    @State private var orderPlaced = false // 添加订单状态
    var stockID: String
    var stockName: String
    var stockExchange: String
    
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
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
            .fixedSize(horizontal: false, vertical: true) // 确保拉桿视图不会随着其他内容变化

            Spacer()
            
            if orderPlaced {
                // 显示下单成功的视图
                VStack {
                    Image(systemName: "checkmark.seal.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.red)
                    Text("Order Placed")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.red)
                }
            } else {
                VStack {
                    TextField("Enter number of shares", text: $numberOfShares)
                        .font(.system(size: 50))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                    
                    Text("How many shares of \(stockName) would you like?")
                        .font(.subheadline)
                        .foregroundColor(.red)
                    
                    Divider()
                        .padding(.vertical)
                    
                    Text("Your total cost will be")
                        .font(.headline)
                    
                    Text("$\(calculateTotalCost(), specifier: "%.2f")")
                        .font(.largeTitle)
                        .bold()
                    
                    if !numberOfShares.isEmpty {
                        if calculateTotalCost() > (balances.first?.balance ?? 0.0) {
                            if let balance = balances.first?.balance {
                                Text("Available: $\(balance, specifier: "%.2f")")
                                    .foregroundColor(.red)
                            }
                            Text("You don't have enough funds")
                                .foregroundColor(.red)
                        }
                    }
                    
                    Spacer()
                    
                    NumberPad(numberOfShares: $numberOfShares, buttonColor: .red)
                        .padding(.horizontal, 20)
                    
                    Button(action: {
                        // Place order action
                        placeOrder()
                    }) {
                        Text("Place Order")
                            .bold()
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isBalanceSufficient() ? Color.red : Color.red.opacity(0.3))
                            .cornerRadius(10)
                    }
                    .padding()
                    .disabled(!isBalanceSufficient())
                }
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            fetchStockPrice()
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
    
    private func calculateTotalCost() -> Double {
        let shares = Double(numberOfShares) ?? 0
        return shares * stockPrice
    }
    
    private func isBalanceSufficient() -> Bool {
        let totalCost = calculateTotalCost()
        let balance = balances.first?.balance ?? 0.0
        return totalCost <= balance && totalCost > 0
    }
    
    private func placeOrder() {
        // Perform order placement logic here
        let totalCost = calculateTotalCost()
        
        // Create a new transaction
        let transaction = Transaction(context: viewContext)
        transaction.id = UUID()
        transaction.amount = totalCost
        transaction.date = Date()
        transaction.type = "Buy-Order"
        
        // Update the balance
        if let balanceEntity = balances.first {
            balanceEntity.balance -= totalCost
        }
        
        // Check if the stock already exists in the portfolio
        let fetchRequest: NSFetchRequest<PortfolioItem> = PortfolioItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "stockId == %@", stockID)
        
        do {
            let portfolioItems = try viewContext.fetch(fetchRequest)
            
            if let existingItem = portfolioItems.first {
                // Update the quantity of the existing portfolio item
                existingItem.quantity += Int64(numberOfShares) ?? 0
            } else {
                // Create a new portfolio item
                let portfolioItem = PortfolioItem(context: viewContext)
                portfolioItem.id = UUID()
                portfolioItem.stockId = stockID
                portfolioItem.stockName = stockName
                portfolioItem.stockExchange = stockExchange
                portfolioItem.timestamp = Date()
                portfolioItem.quantity = Int64(numberOfShares) ?? 0
            }
            
            // Save the context
            try viewContext.save()
            orderPlaced = true
        } catch {
            print("Failed to save transaction or update portfolio: \(error.localizedDescription)")
        }

        // 更新余额，持仓信息和记录交易信息可以在这里完成
        // updateBalance(totalCost: calculateTotalCost())
        // updatePortfolio()
        // recordTransaction(totalCost: calculateTotalCost())
        
        // 订单成功后更新状态
        withAnimation {
            orderPlaced = true
        }
    }
}

class BuyPlaceOrderHelper {
    static func placeOrder(
        stockID: String,
        stockName: String,
        stockExchange: String,
        numberOfShares: Int,
        stockPrice: Double,
        context: NSManagedObjectContext
    ) -> Bool {
        let totalCost = Double(numberOfShares) * stockPrice

        let fetchRequest: NSFetchRequest<Balance> = Balance.fetchRequest()
        fetchRequest.fetchLimit = 1

        do {
            let balances = try context.fetch(fetchRequest)
            if let balance = balances.first, balance.balance >= totalCost {
                // 扣除余额
                balance.balance -= totalCost

                // 新增交易
                let transaction = Transaction(context: context)
                transaction.id = UUID()
                transaction.amount = -totalCost // 確保為負值
                transaction.date = Date()
                transaction.type = "Auto-buy" // 修改為 Auto-buy

                // 更新或新增持仓
                let portfolioFetchRequest: NSFetchRequest<PortfolioItem> = PortfolioItem.fetchRequest()
                portfolioFetchRequest.predicate = NSPredicate(format: "stockId == %@", stockID)

                let portfolioItems = try context.fetch(portfolioFetchRequest)
                if let existingItem = portfolioItems.first {
                    existingItem.quantity += Int64(numberOfShares)
                } else {
                    let portfolioItem = PortfolioItem(context: context)
                    portfolioItem.id = UUID()
                    portfolioItem.stockId = stockID
                    portfolioItem.stockName = stockName
                    portfolioItem.stockExchange = stockExchange
                    portfolioItem.quantity = Int64(numberOfShares)
                    portfolioItem.timestamp = Date()
                }

                // 保存更改
                try context.save()

                // 發送成功通知
                sendNotification(
                    title: "交易成功",
                    body: "股票 \(stockID) (\(stockName)) 已成功下单，金额: $\(String(format: "%.2f", totalCost))。"
                )

                return true
            } else {
                // 發送失敗通知
                sendNotification(
                    title: "交易失败",
                    body: "餘額不足，無法購買股票 \(stockID) (\(stockName))，所需金額: $\(String(format: "%.2f", totalCost))。"
                )
                return false
            }
        } catch {
            print("下单失败：\(error.localizedDescription)")

            // 發送異常通知
            sendNotification(
                title: "交易错误",
                body: "股票 \(stockID) (\(stockName)) 下单时发生错误：\(error.localizedDescription)。"
            )
            return false
        }
    }

    // 發送通知的靜態方法
    private static func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知发送失败：\(error)")
            }
        }
    }
}

struct BuyPlaceOrderView_Previews: PreviewProvider {
    static var previews: some View {
        BuyPlaceOrderView(stockID: "300162", stockName: "雷曼光电", stockExchange: "sz")
    }
}
