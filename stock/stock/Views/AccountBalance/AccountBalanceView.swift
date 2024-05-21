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
    @State private var isShowingWithdrawSheet: Bool = false
    
    @FetchRequest(
        entity: Transaction.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)],
        predicate: NSPredicate(value: true),
        animation: .default)
    private var transactions: FetchedResults<Transaction>
        
    var body: some View {
        ScrollView {
            VStack {
                HeaderAccountView()
                    .padding()
                BalanceCardView(showDepositSheet: $isShowingDepositSheet, showWithdrawSheet: $isShowingWithdrawSheet)
                
                TransactionHeaderView()
                ScrollView {
                    ForEach(transactions.prefix(5), id: \.id) { transaction in
                        TransactionCardView(transactionType: transaction.type ?? "", amount: transaction.amount)
                    }
//                    TransactionCardView(transactionType: "Line", amount: 12.34)
//                    TransactionCardView(transactionType: "Bank", amount: 23.40)
//                    TransactionCardView(transactionType: "ApplePay", amount: 52.97)
//                    TransactionCardView(transactionType: "ApplePay", amount: 52.97)
//                    TransactionCardView(transactionType: "ApplePay", amount: 52.97)
                }
                .frame(maxWidth: .infinity, maxHeight: 500)

                
                Spacer()
            }
            .fullScreenCover(isPresented: $isShowingDepositSheet) {
                NewDepositView()
            }
            .fullScreenCover(isPresented: $isShowingWithdrawSheet) {
                WithdrawView()
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
    static var persistenceController = PersistenceController.shared
    static var previews: some View {
        AccountBalanceView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
