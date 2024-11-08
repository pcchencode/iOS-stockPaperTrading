import SwiftUI

struct QueuePurchaseView: View {
    @State private var searchText: String = ""
    @State private var filteredStocks: [StockViewModel] = []
    @StateObject private var stockListVM = StockListViewModel()
    
    @State private var selectedStock: StockViewModel?
    @State private var numberOfShares: String = ""
    @State private var queueList: [(stock: StockViewModel, quantity: Int, currentPrice: Double?, limitUpPrice: Double?)] = []
    @State private var showDropdown = false

    private func performSearch(keyword: String) {
        if !keyword.isEmpty {
            filteredStocks = stockListVM.stocks.filter { stock in
                stock.stockId.contains(keyword) || stock.name.contains(keyword)
            }
            showDropdown = !filteredStocks.isEmpty
        } else {
            showDropdown = false
        }
    }

    private func fetchCurrentPrice(for stock: StockViewModel, completion: @escaping (Double?, Double?) -> Void) {
        Task {
            do {
                let stockInfoList = try await Webservice().getSinaStockInfo(stockExchange: stock.exchange, stockId: stock.stockId)
                if let stockInfo = stockInfoList.first {
                    let currentPrice = stockInfo.currentPrice
                    let previousClosePrice = stockInfo.previousClosePrice
                    let limitUpPrice = previousClosePrice * 1.1
                    completion(currentPrice, limitUpPrice)
                } else {
                    completion(nil, nil)
                }
            } catch {
                print("Error fetching stock info: \(error)")
                completion(nil, nil)
            }
        }
    }

    var body: some View {
        VStack {
            // 已排隊的股票列表
            ScrollView {
                VStack {
                    ForEach(queueList, id: \.stock.stockId) { item in
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(item.stock.stockId)
                                        .font(.headline)
                                        .bold()
                                    Text(item.stock.name)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        removeFromQueue(stock: item.stock)
                                    }) {
                                        Text("Cancel")
                                            .foregroundColor(.red)
                                    }
                                }
                                
                                HStack(spacing: 10) {
                                    if let price = item.currentPrice {
                                        Text("現價: \(String(format: "%.2f", price))")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                    }
                                    
                                    if let limitUpPrice = item.limitUpPrice {
                                        Text("漲停價: \(String(format: "%.2f", limitUpPrice))")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.top, 2)
                                
                                Text("\(item.quantity) shares")
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .onAppear {
                            fetchCurrentPrice(for: item.stock) { currentPrice, limitUpPrice in
                                if let index = queueList.firstIndex(where: { $0.stock.stockId == item.stock.stockId }) {
                                    queueList[index].currentPrice = currentPrice
                                    queueList[index].limitUpPrice = limitUpPrice
                                }
                            }
                        }
                    }
                }
            }
            
            Divider()
            
            // 搜尋與輸入部分
            VStack {
                Text("Queue Purchase")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                ZStack(alignment: .topLeading) {
                    TextField("Enter stock symbol", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onChange(of: searchText, perform: performSearch)
                        .zIndex(1)
                    
                    if showDropdown {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(filteredStocks.prefix(10), id: \.self) { stock in
                                    Button(action: {
                                        selectedStock = stock
                                        searchText = "\(stock.stockId) \(stock.name)"
                                        showDropdown = false
                                    }) {
                                        HStack {
                                            Text(stock.stockId)
                                                .font(.headline)
                                            Text(stock.name)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 100)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .offset(y: 60)
                        .padding(.bottom, 40)
                        .zIndex(0)
                    }
                }
                
                TextField("Enter number of shares", text: $numberOfShares)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()
                
                Button(action: {
                    if let stock = selectedStock, let quantity = Int(numberOfShares) {
                        addToQueue(stock: stock, quantity: quantity)
                    }
                }) {
                    Text("Add to Queue")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(
                                    LinearGradient(colors: [Color("Gradient1"), Color("Gradient2"), Color("Gradient3")], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                        }
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .background(Color("lightGray"))
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
        }
        .task {
            do {
                await stockListVM.getStockList()
            } catch {
                print(error)
            }
        }
    }
    
    private func addToQueue(stock: StockViewModel, quantity: Int) {
        queueList.append((stock: stock, quantity: quantity, currentPrice: nil, limitUpPrice: nil))
        searchText = ""
        numberOfShares = ""
        selectedStock = nil
    }
    
    private func removeFromQueue(stock: StockViewModel) {
        queueList.removeAll { $0.stock == stock }
    }
}

struct QueuePurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        QueuePurchaseView()
    }
}
