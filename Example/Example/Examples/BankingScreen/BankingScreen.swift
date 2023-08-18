//
//  BankingScreen.swift
//  Example
//
//  Created by Danil Kristalev on 30.12.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderScrollView

struct BankingScreen: View {

    @Environment(\.presentationMode) var presentationMode
    @State var progress: CGFloat = 0
    @State private var isloading = false
    
    let service = BankingService()

    var body: some View {
        ZStack {
            ScalingHeaderScrollView {
                ZStack {
                    Color.hex("#EFF3F5").edgesIgnoringSafeArea(.all)
                    CardView(progress: progress)
                        .padding(.top, 130)
                        .padding(.bottom, 40)
                }
            } content: {
                Color.white.frame(height: 15)
                ForEach(service.transactions) { transaction in
                    TransactionView(transaction: transaction)
                }
                Color.white.frame(height: 15)
            }
            .height(min: 220, max: 372)
            .collapseProgress($progress)
            .allowsHeaderCollapse()
            .pullToLoadMore(isLoading: $isloading, contentOffset: 50) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isloading = false
                }
            }
            topButtons

            VStack {
                Text("Visa Card")
                    .fontRegular(size: 17)
                    .padding(.top, 63)
                Spacer()
            }
        }
        .ignoresSafeArea()
    }

    private var topButtons: some View {
        VStack {
            HStack {
                Button("", action: { self.presentationMode.wrappedValue.dismiss() })
                    .buttonStyle(CircleButtonStyle(imageName: "arrow.backward", background: .white.opacity(0), width: 50, height: 50))
                    .padding(.leading, 17)
                    .padding(.top, 50)
                Spacer()
                Button("", action: { print("Info") })
                    .buttonStyle(CircleButtonStyle(imageName: "ellipsis", background: .white.opacity(0), width: 50, height: 50))
                    .padding(.trailing, 17)
                    .padding(.top, 50)
            }
            Spacer()
        }
        .ignoresSafeArea()
    }
}

struct BankingScreen_Previews: PreviewProvider {
    static var previews: some View {
        BankingScreen()
    }
}
