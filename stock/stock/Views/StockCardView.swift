//
//  StockCardView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/19.
//

import SwiftUI

struct StockCardView: View {
    var stockName: String = "AAPL"
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "appletv.fill")
                    .font(.system(size: 50))
                
                VStack {
                    Text(stockName)
                        .bold()
                        .font(.title3)
                    Text("\(stockName) Inc")
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
        .frame(width: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color("lightGray"))
        )
    }
}

struct StockCardView_Previews: PreviewProvider {
    static var previews: some View {
        StockCardView()
    }
}
