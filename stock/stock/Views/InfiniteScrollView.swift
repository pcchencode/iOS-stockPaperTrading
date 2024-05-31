//
//  InfiniteScrollView.swift
//  stock
//
//  Created by Po-Chu Chen on 5/31/24.
//

import SwiftUI

struct InfiniteScrollView: View {
    private let stockData: [(String, String, String)] = [
        ("上證指數", "27.45", "+0.60"),
        ("深證指數", "229.50", "+3.50"),
        ("NASDAQ", "60.30", "+0.10"),
        ("DowJ", "67.40", "+0.10"),
        ("加權指數", "847.41", "-8.9"),
        ("上證500", "87.76", "+1.9"),
        ("滬深300", "157.14", "-4.7"),
        ("中證500", "37.94", "-6.91"),
    ]
    
//    let stockData: [(String, String, String)]
    @State private var offsetX: CGFloat = 0
    @State private var draggingOffset: CGFloat = 0
    @State private var timer: Timer?
    @State private var isDragging = false

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 20) {
                ForEach(0..<1000, id: \.self) { index in
                    let stock = stockData[index % stockData.count]
                    VStack {
                        Text(stock.0)
                            .foregroundColor(.black)
                            .font(.caption)
                        Text(stock.1)
                            .foregroundColor(.black)
                            .font(.headline)
                        Text(stock.2)
                            .foregroundColor(stock.2.hasPrefix("-") ? .green : .red)
                            .font(.caption)
                    }
                    .frame(width: geometry.size.width / 6.5)
                }
            }
            .offset(x: offsetX + draggingOffset)
            .onAppear {
                let itemWidth = geometry.size.width / 5 + 20 // Adjusted for spacing
                offsetX = -itemWidth * 50
                startTimer(totalWidth: itemWidth * 1000, viewWidth: geometry.size.width)
            }
            .onDisappear {
                stopTimer()
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        draggingOffset = value.translation.width
                        stopTimer()
                    }
                    .onEnded { value in
                        isDragging = false
                        offsetX += draggingOffset
                        draggingOffset = 0

                        let itemWidth = geometry.size.width / 5 + 20 // Adjusted for spacing
                        let totalWidth = itemWidth * 1000

                        if offsetX > 0 {
                            offsetX = -totalWidth + offsetX
                        } else if offsetX < -totalWidth {
                            offsetX = offsetX + totalWidth
                        }
                        startTimer(totalWidth: totalWidth, viewWidth: geometry.size.width)
                    }
            )
        }
    }

    private func startTimer(totalWidth: CGFloat, viewWidth: CGFloat) {
        timer?.invalidate()
        timer = Timer(timeInterval: 0.06, repeats: true) { _ in
            if !isDragging {
                offsetX -= 1
                if offsetX <= -totalWidth {
                    offsetX += totalWidth
                }
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}


#Preview {
    InfiniteScrollView()
}
