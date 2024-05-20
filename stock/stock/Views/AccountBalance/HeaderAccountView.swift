//
//  HeaderAccountView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/30.
//

import SwiftUI

struct HeaderAccountView: View {
    var body: some View {
        HStack {
            Text("Account")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.black)

            Spacer()
        }
    }
}

struct HeaderAccountView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderAccountView()
    }
}
