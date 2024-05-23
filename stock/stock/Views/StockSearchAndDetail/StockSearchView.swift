//
//  StockSearchView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/18.
//

import SwiftUI

struct StockSearchView: View {
    @State private var searchText: String = ""
    @State private var filteredStocks: [StockViewModel] = []
    @StateObject private var stockListVM = StockListViewModel()
    
    @State private var isShowingDetailSheet: Bool = false
    @State private var selectedStock: StockViewModel?
    
    private func performSearch(keyword: String) {
        filteredStocks = stockListVM.stocks.filter { stock in
            stock.stockId.contains(keyword) || stock.name.contains(keyword)
        }
    }
    
    private var stocks: [StockViewModel] {
        filteredStocks.isEmpty ? stockListVM.stocks: filteredStocks
    }
    
    @State private var stock_list = ["Alibaba", "Tencent", "Baidu", "Amazon"] // 假設的股票數據
    
    var body: some View {

        NavigationView {
            List(stocks, id: \.self) { stock in
                VStack(alignment: .leading) {
                    Button {
                        selectedStock = stock
                        isShowingDetailSheet.toggle()
                    } label: {
                        Text(stock.stockId) // 显示股票名称
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(stock.name) // 显示股票代码
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                }
                .sheet(item: $selectedStock) { stock in
                    StockDetailView(stockName: stock.name, stockId: stock.stockId, stockExchange: stock.exchange)
                        //.presentationDetents([.fraction(0.7), .large]) //iOS15沒有這個很坑
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
        }
    }
}


struct StockSearchView_Previews: PreviewProvider {
    static var previews: some View {
        StockSearchView()
    }
}
