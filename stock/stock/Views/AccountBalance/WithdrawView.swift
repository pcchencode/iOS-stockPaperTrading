import SwiftUI

struct WithdrawView: View {
    @Environment(\.self) var env
    
    @State private var amountInput = ""
    @State private var descInput = ""
    @State private var showAlert = false // 新增一個狀態來控制警示的顯示
    @State private var alertMessage = "" // 警示訊息

    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Balance.entity(), sortDescriptors: [])
    private var balances: FetchedResults<Balance>
    
    var body: some View {
        VStack {
            VStack(spacing: 15) {
                Text("Withdraw")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .opacity(0.5)
            
                // TextField
                TextField("0", text: $amountInput)
                    .font(.system(size: 35))
                    .foregroundColor(Color("Gradient2"))
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .background {
                        Text(amountInput == "" ? "0" : amountInput)
                            .font(.system(size: 35))
                            .opacity(0)
                            .overlay(alignment: .leading) {
                                Text("$")
                                    .opacity(0.5)
                                    .offset(x: -15, y: 5)
                            }
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background {
                        Capsule()
                            .fill(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top)
                
                // Description
                Label {
                    TextField("Description", text: $descInput)
                        .padding(.leading, 10)
                } icon: {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 15)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.white)
                }
                .padding(.top, 5)
                
            }
            .frame(maxHeight: .infinity, alignment: .center)
            
            // MARK: Submit Button
            Button {
                addWithdraw()
            } label: {
                Text("提領")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                LinearGradient(colors: [Color("Gradient1"), Color("Gradient2"), Color("Gradient3")], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                    }
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
            }
            .disabled(amountInput == "")
            .opacity(amountInput == "" ? 0.6 : 1)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color("lightGray")
                .ignoresSafeArea()
        }
        .overlay(alignment: .topTrailing) {
            // close button
            Button {
                env.dismiss() // 關閉當前視窗
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.black)
                    .opacity(0.7)
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("錯誤").foregroundColor(.red), // 设置标题为红色
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    // MARK: Checkboxes
    @State var selectedApplePay: Bool = false // 這裡只為先為了刻畫面方便
    @State var selectedLinePay: Bool = false // 這樣做有問題，變成儲值方式可以多選（照理來說是單選）
    @ViewBuilder
    func CustomCheckboxes() -> some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 2)
                    .stroke(.black, lineWidth: 2)
                    .opacity(0.5)
                    .frame(width: 20, height: 20)
                if selectedApplePay {
                    Image(systemName: "checkmark")
                        .font(.caption.bold())
                        .foregroundColor(.green)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selectedApplePay.toggle()
            }
            Text("ApplePay")
                .font(.callout)
                .fontWeight(.semibold)
                .opacity(0.7)
                .padding(.trailing, 10)
            
            ZStack {
                RoundedRectangle(cornerRadius: 2)
                    .stroke(.black, lineWidth: 2)
                    .opacity(0.5)
                    .frame(width: 20, height: 20)
                if selectedLinePay {
                    Image(systemName: "checkmark")
                        .font(.caption.bold())
                        .foregroundColor(.green)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selectedLinePay.toggle()
            }
            Text("ApplePay")
                .font(.callout)
                .fontWeight(.semibold)
                .opacity(0.7)
                .padding(.trailing, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 10)
    }

    // MARK: Add Withdraw Function
    private func addWithdraw() {
        guard let withdrawAmount = Double(amountInput), let balance = balances.first else {
            return
        }
        
        let transaction = Transaction(context: viewContext)
        transaction.id = UUID()
        transaction.date = Date()
        transaction.amount = withdrawAmount
        transaction.type = "Withdraw"
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save deposit: \(error)")
        }

        
        if balance.balance >= withdrawAmount {
            balance.balance -= withdrawAmount
            do {
                try viewContext.save()
                env.dismiss() // 關閉當前視窗
            } catch {
                print("Failed to save withdrawal: \(error)")
            }
        } else {
            alertMessage = "帳戶餘額不足 :("
            showAlert = true
        }
    }
}

#Preview {
    WithdrawView()
}
