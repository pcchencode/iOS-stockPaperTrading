//
//  DateRangePickerView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/5/7.
//

import SwiftUI

struct DateRangePickerView: View {
    let rangeTypes = ["當日行情", "日K", "週K", "月K"]
    @Binding var selectedRange: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0..<rangeTypes.count) { index in
                    //Text(rangeTypes[index])
                    Button {
                        self.selectedRange = rangeTypes[index]
                    } label: {
                        Text(rangeTypes[index])
                            .font(.callout.bold())
                            .padding(8)
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                    .background{
                        if rangeTypes[index] == selectedRange {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.4))
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct DateRangePickerView_Previews: PreviewProvider {
    @State static var dateRange = "當日行情"
    
    static var previews: some View {
        DateRangePickerView(selectedRange: $dateRange)
            .padding(.vertical)
            .previewLayout(.sizeThatFits)
    }
}
