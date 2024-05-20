//
//  StockListViewModel.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/10.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func saveDataToDocuments(_ data: Data, jsonFilename: String = "test.JSON") {

    let jsonFileURL = getDocumentsDirectory().appendingPathComponent(jsonFilename)
    do {
        try data.write(to: jsonFileURL)
    } catch {
        print("Error = \(error)")
    }
}


@MainActor
class StockListViewModel: ObservableObject {

    @Published var stocks: [StockViewModel] = []
    
    func getStockList() async {
        do {
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                // 创建指向特定文件的 URL
                let fileURL = documentsDirectory.appendingPathComponent("stock_list.json")
                // 现在您可以使用 fileURL 来读取或写入该文件
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    do {
                        print("股票列表文件存在於: \(fileURL)")
                        let data = try Data(contentsOf: fileURL)
                        let decoder = JSONDecoder()
                        let stocks = try decoder.decode([Stock].self, from: data)
                        self.stocks = stocks.map(StockViewModel.init)
                        // print(stocks)
                    } catch {
                        print("无法读取文件: \(error)")
                    }
                } else {
                    print("文件不存在，需要从 API 请求数据")
                    // 执行 API 请求...
                    let stocks = try await Webservice().getStocks()
                    self.stocks = stocks.map(StockViewModel.init)
                    // print(stocks)
                    print(type(of: stocks))
                    print(type(of: self.stocks))

                    // Save it to local json file
                    do {
                        let data = try JSONEncoder().encode(stocks)
                        if var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                            url.appendPathComponent("stock_list.json")
                            print("Stock List is saved at: \(url)")
                            try data.write(to: url)
                        }
                    } catch {
                        print(error)
                    }
                }
            } else {
                print("无法找到 Documents 目录")
            }
            

            // 單純送出API請求
            //let ts = try await Webservice().getSinaStockInfo()
            //print(ts.first)

            
//            let stocks = try await Webservice().getStocks()
//            self.stocks = stocks.map(StockViewModel.init)
//            print(type(of: stocks))
//            print(type(of: self.stocks))
            
        } catch {
            print(error)
        }
    }
    
}


struct StockViewModel: Codable, Identifiable, Hashable {
    let id = UUID()  // 添加唯一标识符
    let stock: Stock
    
    var stockId: String {
        stock.stockID
    }
    
    var name: String {
        stock.name
    }
    
    var exchange: String {
        stock.exchange
    }
    
    // 使结构体符合 Hashable 协议
    static func == (lhs: StockViewModel, rhs: StockViewModel) -> Bool {
        return lhs.stockId == rhs.stockId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(stockId)
    }
    
}
