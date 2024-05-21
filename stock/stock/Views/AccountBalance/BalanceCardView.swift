//
//  BalanceCardView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/30.
//

import SwiftUI
import CoreData

struct BalanceCardView: View {
    @State private var isHidden: Bool = false
    @State private var showAlert: Bool = false
    @Binding var showDepositSheet: Bool
    @Binding var showWithdrawSheet: Bool
    
    //Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Balance.entity(), sortDescriptors: [])
    private var balances: FetchedResults<Balance>
    
    var body: some View {
        VStack (alignment: .center) {
            HStack {
                Text("Your Balance")
                    .foregroundColor(Color(UIColor.lightGray))
                    .font(.title2)
                
                if isHidden {
                    Button(action: {
                        isHidden.toggle()
                        print("tapped hide")
                        }) {
                            Image(systemName: "eye.slash")
                                .accentColor(Color.black)
                                .font(.system(size: 30))
                        }
                } else {
                    Button(action: {
                        isHidden.toggle()
                        print("tapped hide")
                        }) {
                            Image(systemName: "eye")
                                .accentColor(Color.black)
                                .font(.system(size: 30))
                        }
                }
            }
            .frame(height: 20) // 固定高度可解決頁面跳動問題
//            Text(isHidden ?"電燈：Of":"電燈：On")
//            Spacer().frame(height: 10)
            
            
            
            if isHidden{
                HStack (alignment: .top) {
                    Text("$ \("****.**")")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            } else {
                HStack (alignment: .top) {
                    if let balance = balances.first?.balance {
                        Text(String(format: "$%.2f", balance))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    } else {
                        Text(String(format: "$%.2f", 8.7))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }               
                }
            }
            
            Spacer().frame(height: 50)
            
            HStack (alignment: .center) {
                Button(action: {
                    print("tapped deposit")
                    // showAlert = true
                    showDepositSheet.toggle()
                    }) {
                        Text("Deposit")
                            .bold()
                            .font(.title)
                            .foregroundStyle(.white)
                            .frame(width: 200)
                            .frame(height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color("Gradient1"), Color("Gradient2"), Color("Gradient3")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            )
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Oops!"),
                              message: Text("Comming Soon :)"),
                              dismissButton: .default(Text("OK")))
                    }
                
                Spacer()
                
                Button(action: {
                    print("tapped withdraw")
                    //showAlert = true
                    showWithdrawSheet.toggle()
                    }) {
                        Text("Withdraw")
                            .bold()
                            .foregroundStyle(.white)
                            .frame(width: 100)
                            .frame(height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray)
                            )
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Oops!"),
                              message: Text("Comming Soon :)"),
                              dismissButton: .default(Text("OK")))
                    }
            }
            .frame(height: 5)
            .frame(maxWidth: 400)

        }
        .frame(height: UIScreen.main.bounds.height/4)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.white)
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
//        .background(
//            RoundedRectangle(cornerRadius: 30)
//                .fill(LinearGradient(gradient: Gradient(colors: [Color("Gradient1"), Color("Gradient2"), Color("Gradient3")]), startPoint: .topLeading, endPoint: .bottomTrailing))
//        )
    }
}

struct BalanceCardView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceCardView(showDepositSheet: .constant(false), showWithdrawSheet: .constant(false))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
