//
//  stockApp.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/9.
//

import SwiftUI

@main
struct stockApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
//            StockSearchView()
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            NewDepositView()
        }
    }
}
