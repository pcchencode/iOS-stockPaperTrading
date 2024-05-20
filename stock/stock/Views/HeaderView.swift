//
//  HeaderView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/17.
//

import SwiftUI

struct HeaderView: View {
    @Binding var showSheet: Bool
    var body: some View {
        HStack {
            Text("Dashboard")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.black)

            Spacer()

            Button(action: {
                print("tapped search")
                showSheet.toggle()
                }) {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .accentColor(Color.black)
                        .font(.system(size: 40))
                }
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(showSheet: .constant(false))
    }
}
