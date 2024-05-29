//
//  MainPageView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/17.
//

import SwiftUI
import CoreData

struct MainPageView: View {
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \StockItem.order, ascending: true)],
        animation: .default)
    private var items: FetchedResults<StockItem>

    // Fetch PortfolioItems
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PortfolioItem.timestamp, ascending: true)],
        animation: .default)
    private var portfolioItems: FetchedResults<PortfolioItem>
    
    @State private var isShowingStockSearchSheet: Bool = false
    @State private var isShowingEditWatchlistSheet: Bool = false
    @State private var refreshID = UUID()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                        .frame(height: 130) // 頂部的留白區域，確保 `HeaderView` 不會遮擋 `RefreshableScrollView`
                    
                    RefreshableScrollView {
                        VStack(spacing: 16) { // 添加適當的間距
                            PortfolioCardView()
                                .padding(.top, 0) // 移除 PortfolioCardView 的頂部間距
                            
                            PortfolioView()
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(portfolioItems, id: \.self) { portfolioItem in
                                        NavigationLink(destination: StockDetailView(stockName: portfolioItem.stockName ?? "", stockId: portfolioItem.stockId ?? "", stockExchange: portfolioItem.stockExchange ?? "")) {
                                            PortfolioCards(
                                                stockId: portfolioItem.stockId ?? "",
                                                stockName: portfolioItem.stockName ?? "",
                                                stockExchange: portfolioItem.stockExchange ?? "",
                                                stockQuantity: portfolioItem.quantity
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            
                            WatchListView(showSheet: $isShowingEditWatchlistSheet)

                            ScrollView {
                                ForEach(items, id: \.self) { item in
                                    NavigationLink(destination: StockDetailView(stockName: item.stockName ?? "", stockId: item.stockId ?? "", stockExchange: item.stockExchange ?? "")) {
                                        StockCardView(stockName: item.stockName ?? "", stockId: item.stockId ?? "", stockExchange: item.stockExchange ?? "")
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: 500)
                            
                            Spacer()
                        }
                        .padding()
                        .edgesIgnoringSafeArea(.bottom)
                        .sheet(isPresented: $isShowingStockSearchSheet) {
                            StockSearchView()
                        }
                        .sheet(isPresented: $isShowingEditWatchlistSheet) {
                            EditWatchlistView()
                        }
                    } onRefresh: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            refreshID = UUID() // 改变 ID 以触发视图重新加载
                        }
                    }
                    .id(refreshID)
                }
                
                VStack {
                    HeaderView(showSheet: $isShowingStockSearchSheet)
                        .background(.ultraThinMaterial) // 使用毛玻璃效果背景
                        .padding(.top, 0) // 調整頂部padding
                        .zIndex(1)
                    Spacer()
                }
            }
        }
    }
}

struct MainPageView_Previews: PreviewProvider {
    static var persistenceController = PersistenceController.shared
    static var previews: some View {
        MainPageView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
