//
//  BankingScreen.swift
//  Example
//
//  Created by Danil Kristalev on 30.12.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderView

struct BankingScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isCollapsed: Bool = false
    @State var progress: CGFloat = 0
    
    let service = BankingService()
    
    var body: some View {
        ZStack {
            ScalingHeaderView {
                ZStack {
                    Color.hex("#EFF3F5").edgesIgnoringSafeArea(.all)
                    CardView(isCollapsed: $isCollapsed)
                        .padding(.top, 130)
                        .padding(.bottom, 40)
                        .onTapGesture {
                            isCollapsed.toggle()
                        }
                    VStack {
                        Text("Visa Card")
                            .font(.custom("Circe", size: 17))
                            .padding(.top, 75)
                        Spacer()
                    }
                    
                }
            } content: {
                
                
            }
            .height(max: 372)
            .progress($progress)
            .allowsHeaderGrowth()
            
            topButtons
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
