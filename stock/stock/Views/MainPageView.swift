//
//  MainPageView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/17.
//

import SwiftUI
import CoreData

struct MainPageView: View {
    //Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \StockItem.order, ascending: true)],
        animation: .default)
    private var items: FetchedResults<StockItem>
    @State private var isShowingStockSearchSheet: Bool = false
    @State private var isShowingEditWatchlistSheet: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                HeaderView(showSheet: $isShowingStockSearchSheet)
                    .padding()
                PortfolioCardView()
                
                PortfolioView()
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        PortfolioCards()
                        PortfolioCards()
                        PortfolioCards()
                        PortfolioCards()
                    }

                }
                    
                WatchListView(showSheet: $isShowingEditWatchlistSheet)

                ScrollView {
                    ForEach(items, id: \.self) { item in
                        StockCardView(stockName: item.stockName ?? "")
                    }
//                    StockCardView()
//                    StockCardView(stockName: "GOOG")
//                    StockCardView()
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
