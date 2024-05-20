//
//  TransactionHeaderView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/30.
//

import SwiftUI

struct TransactionHeaderView: View {
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Transactions")
                    .font(.title)
                    .bold()
                Spacer()
                
                Button(action: {
                    print("tapped hide")
                    showAlert = true
                    }) {
                        Text("View all")
                            .bold()
                            .foregroundColor(Color("themeRed"))

                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Oops!"),
                              message: Text("Comming Soon :)"),
                              dismissButton: .default(Text("OK")))
                    }
            }
        }
        
    }
}

struct TransactionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionHeaderView()
    }
}
