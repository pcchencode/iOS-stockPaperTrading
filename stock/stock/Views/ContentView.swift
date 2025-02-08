//
//  ContentView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/9.
//

import SwiftUI

import CoreData

struct ContentView: View {
    var body: some View {
        NavigationView {
            Rectangle()
                .fill(.red)
                .frame(width: 200)
                .edgesIgnoringSafeArea(.top)
                .navigationTitle("Hello")
                .navigationBarTitleDisplayMode(.inline)

                // New modifiers
                .toolbarBackground(.clear, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
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
