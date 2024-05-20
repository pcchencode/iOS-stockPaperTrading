//
//  EditWatchlistView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/26.
//

import SwiftUI
import CoreData

struct EditWatchlistView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: StockItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \StockItem.order, ascending: true)],
        animation: .default)
    private var items: FetchedResults<StockItem>

    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Text(item.stockName ?? "Unknown")
                        Text("\(item.order)")
                    }
                }
                .onMove(perform: moveItem)
                .onDelete(perform: deleteItem)
            }
            .navigationTitle("Watchlist")
            .navigationBarItems(leading: EditButton(), trailing: NavigationLink("Add", destination: AddStockSearchView()))
        }
    }
    private func moveItem(at sets:IndexSet,destination:Int){
        print(NSPersistentContainer.defaultDirectoryURL())
        let itemToMove = sets.first!
        
        if itemToMove < destination{
            var startIndex = itemToMove + 1
            let endIndex = destination - 1
            var startOrder = items[itemToMove].order
            while startIndex <= endIndex{
                items[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            items[itemToMove].order = startOrder
        }
        else if destination < itemToMove{
            var startIndex = destination
            let endIndex = itemToMove - 1
            var startOrder = items[destination].order + 1
            let newOrder = items[destination].order
            while startIndex <= endIndex{
                items[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            items[itemToMove].order = newOrder
        }
        
        do{
            try viewContext.save()
        }
        catch{
            print(error.localizedDescription)
        }
        
    }
    
    private func deleteItem(at offset:IndexSet){
        withAnimation{
            offset.map{ items[$0] }.forEach(viewContext.delete)
            do{
                try viewContext.save()
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }

   
}

struct EditWatchlistView_Previews: PreviewProvider {
    static var persistenceController = PersistenceController.shared
    static var previews: some View {
        EditWatchlistView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
