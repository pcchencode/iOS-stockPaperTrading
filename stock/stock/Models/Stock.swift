//
//  Stock.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/10.
//

import Foundation

struct StockResponse: Codable {
    let stocks: [Stock]
    
//    private enum CodingKeys: String, CodingKey {
//        case stocks = "Search"
//    }
}

struct Stock: Codable {
    let id = UUID()
    let stockID: String
    let name: String
    let exchange: String
    
    private enum CodingKeys: String, CodingKey {
        case stockID = "dm"
        case name = "mc"
        case exchange = "jys"
    }
    
}
