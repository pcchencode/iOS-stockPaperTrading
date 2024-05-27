//
//  SinaStockInfo.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/5/18.
//

import Foundation

struct SinaStockInfo {
    let name: String
    let openPrice: Double
    let previousClosePrice: Double
    let currentPrice: Double
    let highestPrice: Double
    let lowestPrice: Double
    let bidPrice: Double
    let askPrice: Double
    let volume: Int
    let turnover: Double
    let bid1Volume: Int
    let bid1Price: Double
    let bid2Volume: Int
    let bid2Price: Double
    let bid3Volume: Int
    let bid3Price: Double
    let bid4Volume: Int
    let bid4Price: Double
    let bid5Volume: Int
    let bid5Price: Double
    let ask1Volume: Int
    let ask1Price: Double
    let ask2Volume: Int
    let ask2Price: Double
    let ask3Volume: Int
    let ask3Price: Double
    let ask4Volume: Int
    let ask4Price: Double
    let ask5Volume: Int
    let ask5Price: Double
    let date: String
    let time: String
}

func parseStockInfo(from string: String) -> SinaStockInfo? {
    // 去掉最后的逗号
    let cleanedString = string.hasSuffix(",") ? String(string.dropLast()) : string
    let components = cleanedString.components(separatedBy: ",")
    // 加入檢查段，不然模擬器會崩潰
    guard components.count <= 34 else {
        print("Expected less and equal to 34 components, but found \(components.count)")
        return nil
    }
    
    return SinaStockInfo(
        name: components[0],
        openPrice: Double(components[1]) ?? 0.0,
        previousClosePrice: Double(components[2]) ?? 0.0,
        currentPrice: Double(components[3]) ?? 0.0,
        highestPrice: Double(components[4]) ?? 0.0,
        lowestPrice: Double(components[5]) ?? 0.0,
        bidPrice: Double(components[6]) ?? 0.0,
        askPrice: Double(components[7]) ?? 0.0,
        volume: Int(components[8]) ?? 0,
        turnover: Double(components[9]) ?? 0.0,
        bid1Volume: Int(components[10]) ?? 0,
        bid1Price: Double(components[11]) ?? 0.0,
        bid2Volume: Int(components[12]) ?? 0,
        bid2Price: Double(components[13]) ?? 0.0,
        bid3Volume: Int(components[14]) ?? 0,
        bid3Price: Double(components[15]) ?? 0.0,
        bid4Volume: Int(components[16]) ?? 0,
        bid4Price: Double(components[17]) ?? 0.0,
        bid5Volume: Int(components[18]) ?? 0,
        bid5Price: Double(components[19]) ?? 0.0,
        ask1Volume: Int(components[20]) ?? 0,
        ask1Price: Double(components[21]) ?? 0.0,
        ask2Volume: Int(components[22]) ?? 0,
        ask2Price: Double(components[23]) ?? 0.0,
        ask3Volume: Int(components[24]) ?? 0,
        ask3Price: Double(components[25]) ?? 0.0,
        ask4Volume: Int(components[26]) ?? 0,
        ask4Price: Double(components[27]) ?? 0.0,
        ask5Volume: Int(components[28]) ?? 0,
        ask5Price: Double(components[29]) ?? 0.0,
        date: components[30],
        time: components[31]
    )
}
func extractStockData(from response: String) -> String? {
    guard let range = response.range(of: "=") else {
        return nil
    }
    let extractedString = String(response[range.upperBound...])
    let trimmedString = extractedString.trimmingCharacters(in: .whitespacesAndNewlines)
    // 去掉最后的分号
    if trimmedString.hasSuffix(";") {
        return String(trimmedString.dropLast())
    }
    return trimmedString
}
