//
//  PortfolioView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/19.
//

import SwiftUI

struct PortfolioView: View {
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Your Portfolio")
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

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
