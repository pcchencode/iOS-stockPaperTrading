//
//  ContentView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/9.
//

import SwiftUI

import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \StockItem.order, ascending: true)],
        animation: .default)
    private var items: FetchedResults<StockItem>
    
    @State private var addItemView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    HStack{
                        Text(item.stockName ?? "")
                        Text("\(item.order)")
                    }
                }
                .onMove(perform: moveItem)
                .onDelete(perform: deleteItem)
            }
            .navigationTitle("Order List")
            .sheet(isPresented: $addItemView){
                AddItemView()
            }
            .navigationBarItems(leading: EditButton())
            .navigationBarItems(trailing: NavigationLink("Add", destination: AddStockSearchView()))
//            .toolbar {
//#if os(iOS)
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//#endif
//                ToolbarItem {
//                    Button(action: {
//                        addItemView.toggle()
//                    }) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
        }
    }
    
    private func moveItem(at sets:IndexSet,destination:Int){
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



struct ContentView_Previews: PreviewProvider {
    static var persistenceController = PersistenceController.shared
    static var previews: some View {
//        ContentView()
        ContentView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
