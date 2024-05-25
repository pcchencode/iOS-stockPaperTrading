//
//  NumberPad.swift
//  stock
//
//  Created by Po-Chu Chen on 5/23/24.
//

import SwiftUI

struct NumberPad: View {
    @Binding var numberOfShares: String
    var buttonColor: Color
    
    let buttons: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["", "0", "⌫"]
    ]
    
    var body: some View {
        VStack(spacing: 20) { // 增加垂直间距
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 20) { // 增加水平间距
                    ForEach(row, id: \.self) { button in
                        if button.isEmpty {
                            Spacer()
                                .frame(width: 100, height: 100) // 设置空白间隔的大小
                        } else {
                            Button(action: {
                                self.buttonTapped(button: button)
                            }) {
                                Text(button)
                                    .font(.largeTitle)
                                    .frame(width: 100, height: 100) // 增加按钮尺寸
                                    .background(buttonColor.opacity(0.1))
                                    .foregroundColor(buttonColor) // 设置按钮文本颜色为红色
                                    .cornerRadius(50) // 更新圆角半径以适应新的尺寸
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func buttonTapped(button: String) {
        switch button {
        case "⌫":
            if !numberOfShares.isEmpty {
                numberOfShares.removeLast()
            }
        default:
            numberOfShares.append(button)
        }
    }
}


struct NumberPad_Previews: PreviewProvider {
    static var previews: some View {
        NumberPad(numberOfShares: .constant(""), buttonColor: .red)
    }
}
