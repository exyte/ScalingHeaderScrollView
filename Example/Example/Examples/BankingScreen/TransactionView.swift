//
//  TransactionView.swift
//  Example
//
//  Created by Danil Kristalev on 30.12.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI

struct TransactionView: View {
    let transaction: BankTransaction
    
    var body: some View {
        HStack(spacing: 16) {
            
            Image(transaction.iconName)
                .resizable()
                .frame(width: 46, height: 46)
            
            VStack(alignment: .leading) {
                Text(transaction.title)
                    .foregroundColor(Color.hex("#0C0C0C"))
                    .fontRegular(size: 16)
                Text(transaction.category)
                    .foregroundColor(Color.black.opacity(0.4))
                    .fontRegular(size: 13)
            }
            .frame(height: 46)
            
            Spacer()
            
            Text("\(String(format: "%.2f", transaction.balance)) $")
                .foregroundColor(transaction.balance > 0 ? Color.hex("#01B74E") : Color.hex("#0C0C0C"))
                .fontBold(size: 16)
        }
        .padding(.horizontal, 24)
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(transaction: BankTransaction(iconName: "Asos", date: nil, title: "Asos", category: "Сlothes and accessories", balance: -36.67))
    }
}
