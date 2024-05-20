//
//  PortfolioCards.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/19.
//

import SwiftUI

struct PortfolioCards: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "appletv.fill")
                    .font(.system(size: 50))
                
                VStack {
                    Text("AAPL")
                        .bold()
                        .font(.title3)
                    Text("Apple Inc")
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                
                Spacer()
                
                Text("1.2%")
                    .bold()
                    .foregroundColor(.green)
            }
            Spacer()
            HStack {
                Text("$137.59")
                    .bold()
                    .font(.title)
                Spacer()
                Text("Graph")
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
        .padding(5)
        .frame(height: UIScreen.main.bounds.height/6)
        .frame(width: 150)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color("lightGray"))
        )
    }
}

struct PortfolioCards_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioCards()
    }
}
