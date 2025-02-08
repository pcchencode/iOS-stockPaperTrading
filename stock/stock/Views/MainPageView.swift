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
    @State private var isRefreshing: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 使用 `GeometryReader` 监控 `ScrollView` 的滚动偏移量
                RefreshableScrollView {
                    VStack() {
                        //Color.white.frame(height: 5)
                        InfiniteScrollView()
                            .frame(height: 60)
                        
                        PortfolioCardView()
                            //.padding(.top, 0) // 移除 PortfolioCardView 的顶部间距
                        
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
                    withAnimation {
                        isRefreshing = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            isRefreshing = false
                        }
                        refreshID = UUID() // 改变 ID 以触发视图重新加载
                    }
                }
                .id(refreshID)
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .edgesIgnoringSafeArea(.top)
            // New modifiers
            .toolbarBackground(.clear, for: .navigationBar)
            //.toolbarColorScheme(.dark, for: .navigationBar)
            //.toolbarBackground(.visible, for: .navigationBar)

            .toolbar {
                ToolbarItem(placement: .principal) {
                    HeaderView(showSheet: $isShowingStockSearchSheet)
                        //.background(.ultraThinMaterial) // 使用毛玻璃效果背景
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
