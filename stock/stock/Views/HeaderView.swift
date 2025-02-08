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
            Spacer()
            Button(action: {
                showSheet = true
            }) {
                Image(systemName: "magnifyingglass.circle.fill")
                    .font(.title)
            }
        }
        .padding()

//        VStack(spacing: 8) { // 调整spacing参数，使上方和下方的间距更近
//            HStack {
//                Text("Dashboard")
//                    .font(.largeTitle)
//                    .bold()
//                    .foregroundColor(Color.black)
//
//                Spacer()
//
//                Button(action: {
//                    print("tapped search")
//                    showSheet.toggle()
//                }) {
//                    Image(systemName: "magnifyingglass.circle.fill")
//                        .accentColor(Color.black)
//                        .font(.system(size: 40))
//                }
//            }
//            .padding([.top, .horizontal, .bottom], 5)
    }
}


struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(showSheet: .constant(false))
    }
}

