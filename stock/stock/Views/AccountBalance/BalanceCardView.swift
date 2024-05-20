//
//  BalanceCardView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/30.
//

import SwiftUI

struct BalanceCardView: View {
    @State private var isHidden: Bool = false
    @State private var showAlert: Bool = false
    @Binding var showSheet: Bool
    
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
                                .accentColor(Color.white)
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
            
            Spacer().frame(height: 10)
            
            if isHidden{
                HStack (alignment: .top) {
                    Text("$ *****")
                        .foregroundColor(Color.black)
                        .bold()
                        .font(.system(size: 50))
                }
            } else {
                HStack (alignment: .top) {
                    Text("$9487.94")
                        .foregroundColor(Color.black)
                        .bold()
                        .font(.system(size: 50))
                }
            }
            
            Spacer().frame(height: 50)
            HStack (alignment: .center) {
                Button(action: {
                    print("tapped deposit")
                    // showAlert = true
                    showSheet.toggle()
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
//                            .background(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .fill(.green)
//                            )
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Oops!"),
                              message: Text("Comming Soon :)"),
                              dismissButton: .default(Text("OK")))
                    }
                
                Spacer()
                
                Button(action: {
                    print("tapped withdraw")
                    showAlert = true
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
        BalanceCardView(showSheet: .constant(false))
    }
}
