//
//  MainView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/19.
//

import SwiftUI

struct MainView: View {
    //Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \StockItem.order, ascending: true)],
        animation: .default)
    private var items: FetchedResults<StockItem>
    
    //Core Data
    @FetchRequest(entity: Balance.entity(), sortDescriptors: [])
    private var balances: FetchedResults<Balance>

    
    var body: some View {
        TabView {
            MainPageView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("首頁")
                        .font(.largeTitle)
                }
            
            QueuePurchaseView()
                .tabItem {
                    Image(systemName: "text.line.first.and.arrowtriangle.forward")
                    Text("排隊購買")
                        .font(.largeTitle)
                }
            
            
            AccountBalanceView()
                .tabItem {
                    Label("帳戶餘額", systemImage: "person.crop.circle.fill")
                }
        
        }
        .accentColor(Color("themeBlue"))
    }
}

struct MainView_Previews: PreviewProvider {
    static var persistenceController = PersistenceController.shared
    static var previews: some View {
        MainView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
