//
//  PortfolioCardView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/18.
//

import SwiftUI

struct PortfolioCardView: View {
    @State private var isHidden: Bool = false
    @State private var showAlert: Bool = false
    @State private var totalPortfolioValue: Double = 0.0
    @State private var timer: Timer?
    
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: PortfolioItem.entity(), sortDescriptors: [])
    private var portfolioItems: FetchedResults<PortfolioItem>
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Your Total Portfolio Value")
                    .foregroundColor(Color(UIColor.lightGray))
                    .font(.title2)
                
                if isHidden {
                    Button(action: {
                        isHidden.toggle()
                        print("tapped hide")
                    }) {
                        Image(systemName: "eye.slash")
                            .accentColor(Color.white)
                            .font(.system(size: 30))
                    }
                } else {
                    Button(action: {
                        isHidden.toggle()
                        print("tapped hide")
                    }) {
                        Image(systemName: "eye")
                            .accentColor(Color.white)
                            .font(.system(size: 30))
                    }
                }
            }
            .frame(height: 20) // 固定高度可解決頁面跳動問題
            
            Spacer().frame(height: 10)
            
            if isHidden {
                HStack(alignment: .top) {
                    Text("$ *****")
                        .foregroundColor(Color.white)
                        .bold()
                        .font(.system(size: 50))
                    Text("  ***  ")
                        .foregroundColor(Color.green)
                        .font(.title3)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.white)
                        )
                }
            } else {
                HStack(alignment: .top) {
                    Text("$\(totalPortfolioValue, specifier: "%.2f")")
                        .foregroundColor(Color.white)
                        .bold()
                        .font(.system(size: 50))
                    Text("  ▲ 2.1%  ") // 这里可以计算实际的涨跌幅
                        .foregroundColor(Color.green)
                        .font(.title3)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.white)
                        )
                }
            }
            
            HStack(alignment: .center) {
                Button(action: {
                    print("tapped hide")
                    showAlert = true
                }) {
                    Text("View all")
                        .bold()
                        .frame(width: 100)
                        .frame(height: 30)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        )
                    
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Oops!"),
                          message: Text("Comming Soon :)"),
                          dismissButton: .default(Text("OK")))
                }
            }
            .frame(height: 5)
            .frame(maxWidth: 400)
        }
        .frame(height: UIScreen.main.bounds.height / 5)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(LinearGradient(gradient: Gradient(colors: [Color("themeBlue"), Color("themePink")]), startPoint: .top, endPoint: .bottom))
        )
        .onAppear {
            fetchData()
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func fetchData() {
        Task {
            do {
                var totalValue: Double = 0.0
                for item in portfolioItems {
                    let stockInfoList = try await Webservice().getSinaStockInfo(stockExchange: item.stockExchange ?? "", stockId: item.stockId ?? "")
                    if let stockInfo = stockInfoList.first {
                        totalValue += stockInfo.currentPrice * Double(item.quantity)
                    }
                }
                DispatchQueue.main.async {
                    self.totalPortfolioValue = totalValue
                }
            } catch {
                print("Failed to fetch stock information: \(error)")
            }
        }
    }
    
    private func startTimer() {
        //每10秒會去打API取得Portfolio的現價(先暫時調高不要一直打)
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            fetchData()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

struct PortfolioCardView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioCardView()
    }
}
