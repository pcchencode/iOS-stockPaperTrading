//
//  AddStockSearchView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/26.
//

import SwiftUI

struct AddStockSearchView: View {
    @State private var searchText: String = ""
    @State private var filteredStocks: [StockViewModel] = []
    @StateObject private var stockListVM = StockListViewModel()
    
    @State private var isShowingDetailSheet: Bool = false
    @State private var selectedStock: StockViewModel?
    @State private var shouldShowDetailView: Bool = false
    
    private func performSearch(keyword: String) {
        filteredStocks = stockListVM.stocks.filter { stock in
            stock.stockId.contains(keyword) || stock.name.contains(keyword)
        }
    }
    
    private var stocks: [StockViewModel] {
        filteredStocks.isEmpty ? stockListVM.stocks : filteredStocks
    }

    var body: some View {
        VStack(spacing: 0) {
            // 在這裡添加拉桿視圖
            RoundedRectangle(cornerRadius: 5.0)
                .frame(width: 40, height: 6)
                .foregroundColor(.gray)
                .padding(.top, 8)
                .padding(.bottom, 12)
            
            // 單獨是為了把 NavigationView 拿掉
            VStack(spacing: 0) {
                List(stocks, id: \.self) { stock in
                    VStack(alignment: .leading) {
                        Button {
                            selectedStock = stock
                            shouldShowDetailView.toggle() // 用於強制視圖刷新
                        } label: {
                            Text(stock.stockId) // 顯示股票名稱
                                .font(.headline)
                                .foregroundColor(.black)
                            Text(stock.name) // 顯示股票代碼
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                    }
                }
                .task {
                    do {
                        await stockListVM.getStockList()
                    } catch {
                        print(error)
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "輸入股票名稱或代碼")
                .onChange(of: searchText, perform: performSearch)
                .navigationTitle("Stocks")
                .background(Color("lightGray").ignoresSafeArea()) // 設置背景顏色
            }
            .background(Color("lightGray")) // 設置背景顏色
        }
        .sheet(isPresented: $isShowingDetailSheet) {
            if let stock = selectedStock {
                StockDetailView(stockName: stock.name, stockId: stock.stockId, stockExchange: stock.exchange)
                    .onAppear {
                        print("StockDetailView appeared for \(stock.name)")
                    }
                    .presentationDetents([.fraction(0.8), .large]) //iOS15沒有這個很坑
            } else {
                Text("Loading...")
            }
        }
        .onChange(of: shouldShowDetailView) { _ in
            isShowingDetailSheet = true
        }
        .background(Color("lightGray").ignoresSafeArea())
        
    }
}

struct AddStockSearchView_Previews: PreviewProvider {
    static var previews: some View {
        AddStockSearchView()
    }
}
