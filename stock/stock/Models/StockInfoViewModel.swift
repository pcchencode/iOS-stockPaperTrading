//
//  StockInfoViewModel.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/13.
//

import Foundation

struct StockInfo: Decodable {
    var name: String
    var ename: String
    // 添加其他需要展示的字段
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case ename = "ename"
    }
    
}

struct StockDetail: Decodable {
    var name: String
    var ename: String
    // 添加您需要展示的其他字段
}

class StockInfoViewModel: ObservableObject {
//    @Published var stockInfo: StockInfo?
//    @Published var stockInfo: StockInfo = StockInfo(name: "", ename: "")
    
    @Published var stockData: String = "正在加载..."
    @Published var stockDetail: StockDetail?

    func loadStockData(stockId: String) {
        // ...设置URL和URLRequest...
        guard let url = URL(string: "https://api.mairui.club/hscp/gsjj/\(stockId)/25874295b78c614f21") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("https://finance.sina.com.cn/", forHTTPHeaderField: "Referer")
        print("getting........")
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.stockData = "加载失败: \(error.localizedDescription)"
                }
                return
            }
            
            if let data = data, let stockDetails = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self?.stockData = stockDetails
                    self?.parseStockDetail(jsonString: stockDetails)
                }
            } else {
                DispatchQueue.main.async {
                    self?.stockData = "数据编码错误或响应为空"
                }
            }
        }.resume()
    }

    func parseStockDetail(jsonString: String) {
        guard let jsonData = jsonString.data(using: .utf8) else { return }
        let decoder = JSONDecoder()
        do {
            let detail = try decoder.decode(StockDetail.self, from: jsonData)
            DispatchQueue.main.async {
                self.stockDetail = detail
            }
        } catch {
            DispatchQueue.main.async {
                self.stockData = "JSON 解析失败: \(error)"
            }
        }
    }

}
