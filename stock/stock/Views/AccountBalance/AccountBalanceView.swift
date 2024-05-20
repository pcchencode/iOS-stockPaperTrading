//
//  AccountBalanceView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/30.
//

import SwiftUI

struct AccountBalanceView: View {
    @State private var isShowingStockSearchSheet: Bool = false
    @State private var isShowingEditWatchlistSheet: Bool = false
    @State private var isShowingDepositSheet: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                HeaderAccountView()
                    .padding()
                BalanceCardView(showSheet: $isShowingDepositSheet)
                
                TransactionHeaderView()
                ScrollView {
                    TransactionCardView(stockName: "Line", amount: 12.34)
                    TransactionCardView(stockName: "Bank", amount: 23.40)
                    TransactionCardView(stockName: "ApplePay", amount: 52.97)
                    TransactionCardView(stockName: "ApplePay", amount: 52.97)
                    TransactionCardView(stockName: "ApplePay", amount: 52.97)
                }
                .frame(maxWidth: .infinity, maxHeight: 500)

                
                Spacer()
            }
            .fullScreenCover(isPresented: $isShowingDepositSheet) {
                NewDepositView()
            }

        }
        .padding()
        .edgesIgnoringSafeArea(.bottom)
        .background{
            Color("lightGray")
                .ignoresSafeArea()
        }
    }

    
    
}

struct AccountBalanceView_Previews: PreviewProvider {
    static var previews: some View {
        AccountBalanceView()
    }
}
