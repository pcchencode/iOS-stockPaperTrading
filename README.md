# 📈 Stock Paper Trading App (Prototype)

This repository contains the prototype of a **Stock Paper Trading Application**, developed using **SwiftUI**. The application provides users with a simulated stock trading experience, featuring **real-time stock data**, **historical K-Line charts**, and an **automated queue purchase system**. The backend integrates **Sina A-Share API** and **Mairui API** to fetch stock information.

---

## 🚀 Features

- **🔍 Search & View Stocks**  
  Users can search for stocks by ID or name, retrieve real-time prices, and view detailed information with candlestick charts.
- **📊 Portfolio Management**  
  Displays owned stocks, total balance, and transaction history.
- **📝 Queue Purchase & Auto Buy**  
  Users can add stocks to a queue for automatic purchases when specific conditions (e.g., price threshold) are met.
- **💰 Deposit & Withdraw**  
  Allows simulated balance transactions.
- **💾 Persistent Storage**  
  Uses **Core Data** to store stock lists and transactions locally, reducing API calls.
- **📉 Paper Trading**  
  Simulates real-world stock trading by allowing users to place buy and sell orders in a risk-free environment.

---

## 📦 Installation & Setup

### 🔹 Prerequisites
- **macOS** with **Xcode 14+** installed
- A valid **Apple Developer Account** (for running on a real device)
- Clone this repository using Git:

  ```sh
  git clone https://github.com/pcchencode/iOS-stockPaperTrading.git
  cd iOS-stockPaperTrading
  ```

- Open `StockPaperTrading.xcodeproj` in Xcode.
    * Open Existed Project on folder `stock`

### 🔹 Running the App
1. Select an **iOS Simulator** (e.g., `iPhone 14 Pro`) in Xcode.
2. Click the **Run** button (`⌘ + R`) to build and launch the app.
3. The home screen will display the stock portfolio, along with options to search, trade, and manage funds.

---

## 📸 Screenshots

### **1️⃣ Home Screen - Portfolio Overview**
Displays total balance, owned stocks, and recent transactions.

<p align="center">
  <img src="/images/MainPage.png" width="150">
  <img src="/images/Portfolio.png" width="150">
</p>

### **2️⃣ Stock Search & Detail View**
Search stocks using stock ID or name. View price details, bid/ask prices, and interactive K-Line charts.
<p align="center">
  <img src="/images/SearchName.png" width="150">
  <img src="/images/StockDetailView.png" width="150">
</p>


### **3️⃣ Deposit & Withdraw**
Simulate account balance management.
<p align="center">
  <img src="/images/AccountView.png" width="200">
</p>

### **4️⃣ Paper Trading**
Provides a simulated trading experience where users can place buy and sell orders without real financial risk.
<p align="center">
  <img src="/images/BuyOrder.png" width="150">
  <img src="/images/BuyTransaction.png" width="150">
  <img src="/images/SellOrder.png" width="150">
  <img src="/images/SellTransaction.png" width="150">
</p>

### **5️⃣ Queue Purchase System(Auto-Trading)**
Allows users to set conditions for auto-trading. Backend checks stock prices every **10 seconds** and executes trades accordingly.
<p align="center">
  <img src="/images/Q1.png" width="150">
  <img src="/images/Q2.png" width="150">
  <img src="/images/QueueNotification.png" width="150">
  <img src="/images/QueueNotification2.png" width="150">
</p>

---

## 🔧 Tech Stack

| Technology         | Purpose                                      |
|-------------------|----------------------------------------------|
| **SwiftUI**       | Modern UI framework for iOS development     |
| **Core Data**     | Persistent local storage                     |
| **URLSession**    | Networking and API requests                 |
| **UserNotifications** | Push and local notifications             |
| **Sina & Mairui APIs** | Real-time and historical stock data retrieval |

---

## 📄 API Integration

### **Mairui API** (Stock List & Details)
Documentation: https://www.mairui.club/hsdata.html
```plaintext
https://api.mairui.club/hslt/list/{api_key}
```

### **Sina A-Share API** (Real-time Prices)
Documentation: https://www.sinacloud.com/doc/api.html
```plaintext
https://hq.sinajs.cn/list={stock_code}
```

### **Historical K-Line Data** (Candlestick Charts)
Documentation: https://www.sinacloud.com/doc/api.html
```plaintext
https://image.sinajs.cn/newchart/{timeframe}/n/{stock_code}.gif
```

---

## ❗ Known Issues & Future Enhancements
- **Real-Time Stock Updates**: Currently updates every **10 seconds**; may integrate **WebSockets** for live updates.
- **Expanded Trading Features**: Limit orders, stop-loss, and margin trading.
- **Backend Integration**: Potential to connect with actual brokerage accounts.

---

Have fun 😁