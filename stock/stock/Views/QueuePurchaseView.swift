import SwiftUI
import Combine
import UserNotifications

// 监控键盘高度变化
class KeyboardResponder: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    private var cancellable: AnyCancellable?

    init() {
        cancellable = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .sink { notification in
                self.keyboardWillChange(notification: notification)
            }
    }

    private func keyboardWillChange(notification: Notification) {
        if let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let screenHeight = UIScreen.main.bounds.height
            self.keyboardHeight = endFrame.origin.y >= screenHeight ? 0 : endFrame.height
        }
    }

    deinit {
        cancellable?.cancel()
    }
}

struct QueuePurchaseView: View {
    @State private var searchText: String = ""
    @State private var filteredStocks: [StockViewModel] = []
    @StateObject private var stockListVM = StockListViewModel()
    @ObservedObject private var keyboard = KeyboardResponder() // 监控键盘高度
    @State private var selectedStock: StockViewModel?
    @State private var numberOfShares: String = ""
    @State private var queueList: [(stock: StockViewModel, quantity: Int, currentPrice: Double?, limitUpPrice: Double?)] = []
    @State private var showDropdown = false
    @State private var timer: Timer? // 用於控制定時器
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Balance.entity(), sortDescriptors: [])
    private var balances: FetchedResults<Balance>


    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack {
                        Spacer().frame(height: geometry.size.height * 0.2) // 初始间隔，将 Queue Purchase 区块推向下方

                        // 已排队的股票列表
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

                        Spacer().frame(height: 20) // 空间分隔

                        // Queue Purchase 区块
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
                                    .padding(.bottom, 20)
                                    .zIndex(0)
                                }
                            }
                            Spacer().frame(height: 45)
                            
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
                            .id("QueuePurchaseSection") // Queue Purchase 区块的 ID
                            
                            // 发送系统通知按钮
                            Button(action: {
                                //sendNotification()
                                handleSubmitOrder()
                            }) {
                                Text("Submit Order")
                                    .font(.headline)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(
                                                LinearGradient(colors: [Color.blue, Color.purple], startPoint: .leading, endPoint: .trailing)
                                            )
                                    )
                                    .foregroundColor(.white)
                                    .shadow(radius: 5)
                            }
                            .padding()                        }
                        .background(Color("lightGray"))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .padding()
                    }
                    .padding(.bottom, keyboard.keyboardHeight) // 根据键盘高度调整底部间距
                    .animation(.easeOut(duration: 0.3), value: keyboard.keyboardHeight)
                    .onChange(of: keyboard.keyboardHeight) { newHeight in
                        if newHeight > 0 {
                            withAnimation {
                                scrollProxy.scrollTo("QueuePurchaseSection", anchor: .bottom)
                            }
                        }
                    }
                    .onTapGesture {
                        hideKeyboard() // 点击空白区域时隐藏键盘
                    }
                }
            }
        }
        .onAppear {
            requestNotificationPermission() // 请求通知权限
            UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        }
        .task {
            do {
                await stockListVM.getStockList()
            } catch {
                print(error)
            }
        }
    }

    private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "股票已達漲停價"
        content.body = "排隊購買 列隊1:688584上海合晶 已達標，交易完成"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to add notification request: \(error)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
    
    private func handleSubmitOrder() {
        if !queueList.isEmpty {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
                if let randomItem = queueList.randomElement() {
                    fetchCurrentPrice(for: randomItem.stock) { currentPrice, limitUpPrice in
                        if let currentPrice = currentPrice, let limitUpPrice = limitUpPrice {
                            let difference = limitUpPrice - currentPrice
                            if difference > 0 && difference <= 100 {
                                // 呼叫 BuyPlaceOrderHelper.placeOrder
                                let success = BuyPlaceOrderHelper.placeOrder(
                                    stockID: randomItem.stock.stockId,
                                    stockName: randomItem.stock.name,
                                    stockExchange: randomItem.stock.exchange,
                                    numberOfShares: randomItem.quantity,
                                    stockPrice: currentPrice,
                                    context: viewContext // 引用 Core Data 的上下文
                                )

                                if success {
                                    // 發送成功通知
                                    let content = UNMutableNotificationContent()
                                    content.title = "自动下单成功"
                                    content.body = "股票 \(randomItem.stock.stockId) (\(randomItem.stock.name)) 已成功下单。"
                                    content.sound = .default

                                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                                    UNUserNotificationCenter.current().add(request)

                                    // 移除該股票
                                    removeFromQueue(stock: randomItem.stock)
                                } else {
                                    // 發送失敗通知
                                    let content = UNMutableNotificationContent()
                                    content.title = "下单失败"
                                    content.body = "股票 \(randomItem.stock.stockId) (\(randomItem.stock.name)) 下单失败，可能余额不足。"
                                    content.sound = .default

                                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                                    UNUserNotificationCenter.current().add(request)
                                }
                            }
                        }
                    }
                }

                if queueList.isEmpty {
                    timer?.invalidate()
                    timer = nil
                    let content = UNMutableNotificationContent()
                    content.title = "队列已空"
                    content.body = "股票已全部自動購買完成。"
                    content.sound = .default

                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                    UNUserNotificationCenter.current().add(request)
                }
            }
        } else {
            timer?.invalidate()
            timer = nil
            let content = UNMutableNotificationContent()
            content.title = "队列为空"
            content.body = "目前列队中无股票"
            content.sound = .default

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request)
        }
    }
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Failed to request notification permission: \(error)")
            } else {
                print("Notification permission denied.")
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

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func performSearch(keyword: String) {
        if !keyword.isEmpty {
            filteredStocks = stockListVM.stocks.filter { stock in
                stock.stockId.lowercased().contains(keyword.lowercased()) || stock.name.lowercased().contains(keyword.lowercased())
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
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()

    private override init() {
        super.init()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

struct QueuePurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        QueuePurchaseView()
    }
}
