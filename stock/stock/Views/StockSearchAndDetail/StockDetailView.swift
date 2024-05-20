//
//  StockDetailView.swift
//  stock
//
//  Created by PO CHU CHEN on 2024/4/29.
//

import SwiftUI
import CoreData

struct AsyncImageView: View {
    @State private var imageData: Data?

    let imageURL: URL

    var body: some View {
        Group {
            if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 600, maxHeight: 400)
            } else {
                ProgressView()
                    .onAppear(perform: loadImage)
            }
        }
    }

    private func loadImage() {
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    self.imageData = data
                }
            }
        }.resume()
    }
}

struct StockDetailView: View {
    @State var selectedRange = "當日行情"
    @ObservedObject var viewModel = StockInfoViewModel()
    var stockDataString: String = "" // JSON 字符串
    @State private var stockData: String = "正在加载..."
    var stockName: String
    var stockId: String
    var stockExchange: String
    
    //Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var itemTitle = ""
    
    @FetchRequest(sortDescriptors:[]) private var items:FetchedResults<StockItem>
    
    // Quote variable
    @State private var currentPrice: Double?
    @State private var previousClosePrice: Double?
    @State private var changePercentage: Double?
    @State private var openPrice: Double?
    @State private var highestPrice: Double?
    @State private var lowestPrice: Double?
    @State private var volume: Int?
    @State private var bidPrice: Double?
    @State private var askPrice: Double?
        
    private func saveItem(newId: String, newName: String) {
        // 首先檢查是否已經有同樣的 stockId 存在
        let fetchRequest: NSFetchRequest<StockItem> = StockItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "stockId == %@", newId)
        do {
            let results = try viewContext.fetch(fetchRequest)
            if results.isEmpty {
                // 沒有找到相同的 stockId，可以創建新的項目
                let newItem = StockItem(context: viewContext)
                newItem.stockId = newId
                newItem.stockName = newName
                newItem.order = (items.last?.order ?? 0) + 1
                newItem.timestamp = Date()
                try viewContext.save()
            } else {
                // 找到相同的 stockId，不創建新項目
                print("該股票已存在於 Watchlist 中")
            }
        } catch {
            print("無法完成查詢或保存: \(error.localizedDescription)")
        }
    }
        
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
            Spacer()
            headerView.padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
                .padding(.horizontal)
            
            MainScorllView
        }
        .background {
            Color("lightGray")
                .ignoresSafeArea()
        }
        .onAppear {
             // 畫面加載時檢查股票是否已在 Watchlist
             isAddedToWatchlist = isStockAdded(stockId: stockId)
         }

    
    }
    
    private var headerView: some View {
        let shortName: String
        switch stockExchange.lowercased() {
        case "sh":
            shortName = "上海證券交易所"
        case "sz":
            shortName = "深圳證券交易所"
        default:
            shortName = "未知交易所"
        }
        
        return HStack(alignment: .lastTextBaseline) {
            Text("\(stockName)\(stockId)").font(.title.bold()) // 參數化公司名稱 AAPL
            Text(shortName)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(Color(uiColor: .secondaryLabel))
            
            Spacer()
            closeButton
        }
    }
    
    private var MainScorllView: some View {
        ScrollView {
            PriceRowView
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
                .padding(.horizontal)
            
            Divider()
            
            DateRangePickerView(selectedRange: $selectedRange)
            //Text("Chart View Placeholder")
            if selectedRange == "當日行情" {
                AsyncImageView(imageURL: URL(string: "https://image.sinajs.cn/newchart/min/n/\(stockExchange)\(stockId).gif")!)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, minHeight: 220)
            } else if selectedRange == "日K" {
                AsyncImageView(imageURL: URL(string: "https://image.sinajs.cn/newchart/daily/n/\(stockExchange)\(stockId).gif")!)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, minHeight: 220)

            } else if selectedRange == "週K" {
                AsyncImageView(imageURL: URL(string: "https://image.sinajs.cn/newchart/weekly/n/\(stockExchange)\(stockId).gif")!)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, minHeight: 220)

            }
            else {
                AsyncImageView(imageURL: URL(string: "https://image.sinajs.cn/newchart/monthly/n/\(stockExchange)\(stockId).gif")!)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, minHeight: 220)
            }

            
            Divider().padding([.horizontal, .top])
            
            QuoteDetailView
                .frame(maxWidth: .infinity, minHeight: 80)
            
            VStack {
                Spacer()  // 在文字上方添加一個空間填充
                Text("沒有最近報導")
                    .font(.title3)  // 設置字體大小
                    .foregroundColor(.gray)  // 設置字體顏色
                    .padding()  // 增加內邊距
                    .multilineTextAlignment(.center)  // 保證文本居中顯示
                Spacer()  // 在文字下方添加一個空間填充
            }
            .frame(maxWidth: .infinity, minHeight: 300)  // 確保 VStack 填滿父容器
            

        }
        //.scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var QuoteDetailView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                VStack(spacing: 6) {
                    HStack(alignment: .lastTextBaseline) {
                        Text("開盤價")
                            .foregroundColor(.gray)
                        Spacer()
                        //Text("94")
                        if let openPrice = openPrice {
                             Text(String(openPrice))
                         } else {
                             Text("Fetching...")
                         }
                    }
                    HStack(alignment: .lastTextBaseline) {
                        Text("最高價")
                            .foregroundColor(.gray)
                        Spacer()
                        //Text("87")
                        if let highestPrice = highestPrice {
                             Text(String(highestPrice))
                         } else {
                             Text("Fetching...")
                         }
                    }
                    HStack(alignment: .lastTextBaseline) {
                        Text("最低價")
                            .foregroundColor(.gray)
                        Spacer()
                        //Text("22")
                        if let lowestPrice = lowestPrice {
                             Text(String(lowestPrice))
                         } else {
                             Text("Fetching...")
                         }
                    }
                }
                .frame(width: 120)
                .onAppear {
                    Task {
                        do {
                            let stockInfoList = try await Webservice().getSinaStockInfo(stockExchange: stockExchange, stockId: stockId)
                            if let stockInfo = stockInfoList.first {
                                openPrice = stockInfo.openPrice
                                highestPrice = stockInfo.highestPrice
                                lowestPrice = stockInfo.lowestPrice
                            } else {
                                print("No stock information available.")
                            }
                        } catch {
                            print("Failed to fetch stock information: \(error)")
                        }
                    }
                }
                
                VStack(spacing: 6) {
                    HStack(alignment: .lastTextBaseline) {
                        Text("成交量")
                            .foregroundColor(.gray)
                        Spacer()
                        //Text("94")
                        if let volume = volume {
                            //let formattedVolume = volume / 1
                            //Text(String(format: "%.1f萬", formattedVolume))
                            Text("\(volume/10000)萬")
                        } else {
                            Text("Fetching...")
                        }
                    }
                    HStack(alignment: .lastTextBaseline) {
                        Text("委買價")
                            .foregroundColor(.gray)
                        Spacer()
                        //Text("87")
                        if let bidPrice = bidPrice {
                             Text(String(bidPrice))
                         } else {
                             Text("Fetching...")
                         }
                    }
                    HStack(alignment: .lastTextBaseline) {
                        Text("委賣價")
                            .foregroundColor(.gray)
                        Spacer()
                        //Text("22")
                        if let askPrice = askPrice {
                             Text(String(askPrice))
                         } else {
                             Text("Fetching...")
                         }
                    }
                }
                .frame(width: 120)
                .onAppear {
                    Task {
                        do {
                            let stockInfoList = try await Webservice().getSinaStockInfo(stockExchange: stockExchange, stockId: stockId)
                            if let stockInfo = stockInfoList.first {
                                volume = stockInfo.volume
                                bidPrice = stockInfo.bidPrice
                                askPrice = stockInfo.askPrice
                            } else {
                                print("No stock information available.")
                            }
                        } catch {
                            print("Failed to fetch stock information: \(error)")
                        }
                    }
                }
                
                VStack(spacing: 6) {
                    HStack(alignment: .lastTextBaseline) {
                        Text("52W H")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("94")
                    }
                    HStack(alignment: .lastTextBaseline) {
                        Text("52W L")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("87")
                    }
                    HStack(alignment: .lastTextBaseline) {
                        Text("Avg Vol")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("22")
                    }
                }
                .frame(width: 120)
                
                VStack(spacing: 6) {
                    HStack(alignment: .lastTextBaseline) {
                        Text("Yield")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("94")
                    }
                    HStack(alignment: .lastTextBaseline) {
                        Text("Beta")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("87")
                    }
                    HStack(alignment: .lastTextBaseline) {
                        Text("EPS")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("22")
                    }
                }
                .frame(width: 120)
            }
            .padding(.horizontal)
            .font(.caption.weight(.semibold))
            .lineLimit(1)
        }
        
    }
    
    private var PriceRowView: some View {
        HStack(spacing: 4) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    PriceStackView(price: String(format: "%.2f", currentPrice ?? 0.00), diff: "\(changePercentage ?? 0.00 >= 0 ? "+" : "")\(String(format: "%.2f", changePercentage ?? 0.00))%", caption:"中國 · RMB")
                    //PriceStackView(price: "78.9", diff: "-8.7", caption:"After Hours")
                    Spacer()
                    
                }
                .onAppear {
                    Task {
                        do {
                            let stockInfoList = try await Webservice().getSinaStockInfo(stockExchange: stockExchange, stockId: stockId)
                            if let stockInfo = stockInfoList.first {
                                currentPrice = stockInfo.currentPrice
                                previousClosePrice = stockInfo.previousClosePrice
                                if let currentPrice = currentPrice, let previousClosePrice = previousClosePrice {
                                    changePercentage = ((currentPrice - previousClosePrice) / previousClosePrice) * 100
                                }
                            } else {
                                print("No stock information available.")
                            }
                        } catch {
                            print("Failed to fetch stock information: \(error)")
                        }
                    }
                }
                //ExchangeCurrencyView
                Spacer()
            }
            AddWatchlistButton
        }

    }
    
    private var ExchangeCurrencyView: some View {
        HStack(spacing: 4) {
            Text("中國")
            Text("•")
            Text("RMB")
        }
        .font(.subheadline.weight(.semibold))
        .foregroundColor(Color(uiColor: .secondaryLabel))
    }
    
    private func PriceStackView(price: String, diff: String, caption: String) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .lastTextBaseline, spacing: 16) {
                Text(price).font(.headline.bold())
                Text(diff).font(.subheadline.weight(.semibold))
                    .foregroundColor(diff.hasPrefix("-") ? .green: .red)
            }
            Text(caption)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(Color(uiColor: .secondaryLabel))
        }
    }
    
    
//    private var AddWatchlistButton: some View {
//        Button(action: {
//            print("Add to watchlist tapped")
//            saveItem(newId: stockId, newName: stockName)
//        }) {
//            Image(systemName: "plus")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 28, height: 28)
//                .foregroundColor(.white) // Set the icon color to white
//                .padding(10) // Padding around the icon to increase the clickable area
//                .background(
//                    Circle()
//                        .fill(
//                            LinearGradient(gradient: Gradient(colors: [Color("Gradient1"), Color("Gradient2"), Color("Gradient3")]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                        )
//                )
//                .shadow(radius: 3) // Optional: adds a shadow for depth
//        }
//    }

    
    @State private var isAddedToWatchlist: Bool = false
    
    func isStockAdded(stockId: String) -> Bool {
        items.contains(where: { $0.stockId == stockId })
    }

    private var AddWatchlistButton: some View {
        Button(action: {
            if !isAddedToWatchlist {
                saveItem(newId: stockId, newName: stockName)
                isAddedToWatchlist = true
            }
        }) {
            ZStack {
                Circle()
                    .strokeBorder(Color.gray, lineWidth: 2)
                    .frame(width: 48, height: 48)  // 調整外圍圓圈的大小

                Image(systemName: isAddedToWatchlist ? "heart.fill" : "heart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(isAddedToWatchlist ?
                        LinearGradient(gradient: Gradient(colors: [Color("Gradient1"), Color("Gradient2"), Color("Gradient3")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                     : LinearGradient(gradient: Gradient(colors: [.gray]), startPoint: .topLeading, endPoint: .bottomTrailing))  // 條件性地顯示填滿或空心的愛心
            }
            .padding(10)  // 为按钮添加填充以增大点击区域
            .shadow(radius: 3)  // Optional: 添加阴影以增加立体感
        }
        .disabled(isAddedToWatchlist)  // 如果已加入，禁用按鈕
    }

    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Circle()
                .frame(width: 32, height: 32)
                .foregroundColor(.gray.opacity(0.1))
                .overlay {
                    Image(systemName: "xmark")
                        .font(.system(size: 18).bold())
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
        }
        .buttonStyle(.plain)
    }

    

}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // StockDetailView(stockName: "华宝新能", stockId: "301327", stockExchange: "sz")
        StockDetailView(stockName: "雷曼光电", stockId: "300162", stockExchange: "sz")
    }
}
