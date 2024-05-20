//
//  WatchListView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/19.
//

import SwiftUI
import CoreData

struct WatchListView: View {
    @State private var showAlert: Bool = false
    @State private var showingEditWatchlistView = false
    
    @Binding var showSheet: Bool

    
    var body: some View {
        VStack {
            HStack {
                Text("Your Watchlist")
                    .font(.title)
                    .bold()
                Spacer()
                
                Button(action: {
                    print("tapped search")
                    showSheet.toggle()
                    }) {
                        Text("View all")
                            .bold()
                            .foregroundColor(Color("themeRed"))
                    }
            }


        }
    }
}

struct WatchListView_Previews: PreviewProvider {
    static var persistenceController = PersistenceController.shared
    static var previews: some View {
        WatchListView(showSheet: .constant(false))
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
