import SwiftUI

struct NewDepositView: View {
    @Environment(\.self) var env
    
    @State private var amountInput = ""
    @State private var descInput = ""
    
    //Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Balance.entity(), sortDescriptors: [])
    private var balances: FetchedResults<Balance>
    
    var body: some View {
        VStack {
            VStack(spacing: 15) {
                Text("Add Deposit")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .opacity(0.5)
            
                //TextField
                TextField("0", text: $amountInput)
                    .font(.system(size: 35))
                    .foregroundColor(Color("Gradient2"))
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .background {
                        Text(amountInput == "" ? "0" :amountInput)
                            .font(.system(size:35))
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
                
                //CheckBox
                Label {
                    //Bank, ApplyPay, LinePay
                    CustomCheckboxes()
                } icon: {
                    Image(systemName: "creditcard")
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
                
                //Description
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
            
            //MARK: Submit Button
            Button {
                addDeposit()
                env.dismiss() //關閉當前視窗
            } label: {
                Text("Submit")
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
            .disabled(amountInput == "" || (!selectedApplePay && !selectedLinePay && !selectedBank))
            .opacity(amountInput == "" || (!selectedApplePay && !selectedLinePay && !selectedBank) ? 0.6 : 1)
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
                env.dismiss() //關閉當前視窗
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.black)
                    .opacity(0.7)
            }
            .padding()
        }
    }
    
    // MARK: Checkboxes
    @State var selectedApplePay: Bool = false
    @State var selectedLinePay: Bool = false
    @State var selectedBank: Bool = false
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
                selectedApplePay = true
                selectedLinePay = false
                selectedBank = false
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
                selectedApplePay = false
                selectedLinePay = true
                selectedBank = false
            }
            Text("Line")
                .font(.callout)
                .fontWeight(.semibold)
                .opacity(0.7)
                .padding(.trailing, 10)
            
            ZStack {
                RoundedRectangle(cornerRadius: 2)
                    .stroke(.black, lineWidth: 2)
                    .opacity(0.5)
                    .frame(width: 20, height: 20)
                if selectedBank {
                    Image(systemName: "checkmark")
                        .font(.caption.bold())
                        .foregroundColor(.green)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selectedApplePay = false
                selectedLinePay = false
                selectedBank = true
            }
            Text("Bank")
                .font(.callout)
                .fontWeight(.semibold)
                .opacity(0.7)
                .padding(.trailing, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 10)
    }
    
    // MARK: Add Deposit Function
    private func addDeposit() {
        guard let depositAmount = Double(amountInput), let balance = balances.first else {
            return
        }
        balance.balance += depositAmount
        
        let transaction = Transaction(context: viewContext)
        transaction.id = UUID()
        transaction.date = Date()
        transaction.amount = depositAmount
        
        // 根据选中的支付方式设置交易类型
        if selectedApplePay {
            transaction.type = "ApplePay"
        } else if selectedLinePay {
            transaction.type = "Line"
        } else if selectedBank {
            transaction.type = "Bank"
        } else {
            transaction.type = "Deposit"
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save deposit: \(error)")
        }
    }
}

struct NewDepositView_Previews: PreviewProvider {
    static var previews: some View {
        NewDepositView()
    }
}
