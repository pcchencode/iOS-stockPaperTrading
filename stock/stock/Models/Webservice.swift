//
//  Webservice.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/10.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badID
}

// 簡體字編碼
extension String.Encoding {
    static let gb18030: String.Encoding = .init(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))
}


class Webservice {
    
    func getMovies(searchTerm: String) async throws -> [Movie] {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "omdbapi.com"
        components.queryItems = [
            URLQueryItem(name: "s", value: searchTerm),
            URLQueryItem(name: "apikey", value: "564727fa")
        ]
        
        guard let url = components.url else {
            throw NetworkError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badID
        }
        
        let movieResponse = try? JSONDecoder().decode(MovieResponse.self, from: data)
        return movieResponse?.movies ?? []
    }
    
    func getStocks() async throws -> [Stock] {
        var components = URLComponents()
        let apiKeys: [String] = ["b997d4403688d5e65a", "25874295b78c614f21", "58de28c2802a4f4319"]
        let apiKey = apiKeys.randomElement()!
        components.scheme = "http"
        components.host = "api.mairui.club"
        components.path = "/hslt/list/\(apiKey)"
        
        guard let url = components.url else {
            throw NetworkError.badURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        // 打印API返回的資料
//        if let dataString = String(data: data, encoding: .utf8) {
//            print(dataString)
//        }
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badID
        }
        
        do {
            let stock_Response = try JSONDecoder().decode([Stock].self, from: data)
//            print(stock_Response)
//            return stock_Response.stocks // 如果解碼成功，直接返回股票數組
            return stock_Response
        } catch {
            print("解碼錯誤: \(error)") // 打印錯誤信息
            return [] // 解碼失敗時返回一個空數組
        }
        
//        let stockResponse = try? JSONDecoder().decode(StockResponse.self, from: data)
//        return stockResponse?.stocks ?? []

    }
    

    func getSinaStockInfo(stockExchange: String="sh", stockId: String="600519") async throws -> [SinaStockInfo] {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "hq.sinajs.cn"
        components.path = "/list=\(stockExchange)\(stockId)"

        guard let url = components.url else {
            throw NetworkError.badURL
        }

        var request = URLRequest(url: url)
        request.setValue("https://finance.sina.com.cn/", forHTTPHeaderField: "Referer")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print(1)
            throw NetworkError.badID
        }
        
        guard let dataString = String(data: data, encoding: .gb18030) else {
            print(2)
            throw NetworkError.badID
        }
        //print("dataString: \(dataString)")
        
        do {
            if let stockData = extractStockData(from: dataString) {
                //print(stockData)
                if let sinaStockInfo = parseStockInfo(from: stockData) {
                    print(sinaStockInfo)
                    return [sinaStockInfo]
                } else {
                    print("Failed to parse stock information.")
                    return []
                }
            } else {
                print("Failed to extract stock data.")
                return []
            }
        } catch {
            print("解碼錯誤: \(error)") // 打印錯誤信息
            return [] // 解碼失敗時返回一個空數組
        }
    }

}
