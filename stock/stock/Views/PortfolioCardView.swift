//
//  PortfolioCardView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/18.
//

import SwiftUI

struct PortfolioCardView: View {
    @State private var isHidden: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("Your Total Portfolio Value")
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
                                .accentColor(Color.white)
                                .font(.system(size: 30))
                        }
                }
            }
            .frame(height: 20) // 固定高度可解決頁面跳動問題
            
            Spacer().frame(height: 10)
            
            if isHidden{
                HStack (alignment: .top) {
                    Text("$ *****")
                        .foregroundColor(Color.white)
                        .bold()
                        .font(.system(size: 50))
                    Text("  ***  ")
                        .foregroundColor(Color.green)
                        .font(.title3)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.white)
                        )
                }
            } else {
                HStack (alignment: .top) {
                    Text("$1234.56")
                        .foregroundColor(Color.white)
                        .bold()
                        .font(.system(size: 50))
                    Text("  ▲ 2.1%  ")
                        .foregroundColor(Color.green)
                        .font(.title3)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.white)
                        )
                }
            }
            
            HStack (alignment: .center) {
                Button(action: {
                    print("tapped hide")
                    showAlert = true
                    }) {
                        Text("View all")
                            .bold()
                            .frame(width: 100)
                            .frame(height: 30)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
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
        .frame(height: UIScreen.main.bounds.height/5)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(LinearGradient(gradient: Gradient(colors: [Color("themeBlue"), Color("themePink")]), startPoint: .top, endPoint: .bottom))
        )
    }
}

struct PortfolioCardView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioCardView()
    }
}
