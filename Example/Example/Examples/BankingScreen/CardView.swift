//
//  CardView.swift
//  Example
//
//  Created by Danil Kristalev on 30.12.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI

struct CardView: View {

    var progress: CGFloat

    var isCollapsed: Bool {
        progress > 0.6
    }
    
    private var balance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = " "
        
        let number = NSNumber(value: 56112.65)
        let formattedValue = formatter.string(from: number)!
        return "$\(formattedValue)"
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient:
                                        Gradient(colors: [Color.hex("#2B27F3"), Color.hex("#872AFD")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 230)
                .scaleEffect(y: 0.3 + (1 - progress) * 0.7)
                .mask({
                    RoundedRectangle(cornerRadius: 16)
                        .frame(height: 69 + (1 - progress) * 140)
                })
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("BALANCE")
                            .tracking(1.5)
                            .fontRegular(color: Color.white.opacity(0.7), size: 8)
                        
                        Text(balance)
                            .foregroundColor(Color.white)
                            .font(.custom("Circe-ExtraBold", size: 24))
                    }
                    
                    Spacer()
                    
                    if !isCollapsed {
                        Image("Visa")
                            .resizable()
                            .frame(width: 60, height: 18)
                    } else {
                        HStack(spacing: 12) {
                            Text("****")
                            Text("0777")
                        }
                        .fontBold(color: .white, size: 20)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, isCollapsed ? 5 : 32)
                //.padding(.bottom, isCollapsed ? 24 : 0)
                
                if !isCollapsed {
                    Spacer()
                    
                    HStack {
                        Text("****")
                        Spacer()
                        Text("****")
                        Spacer()
                        Text("****")
                        Spacer()
                        Text("0777")
                    }
                    .padding(.horizontal, 40)
                    .fontBold(color: .white, size: 20)
                    
                    Spacer()
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("CARD HOLDER")
                                .tracking(1.5)
                                .fontRegular(color: Color.white.opacity(0.7), size: 8)
                            
                            Text("TOM HOLLAND")
                                .fontBold(color: .white, size: 15)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("EXPIRES")
                                .tracking(1.5)
                                .fontRegular(color: Color.white.opacity(0.7), size: 8)
                            
                            Text("11/24")
                                .fontBold(color: .white, size: 15)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 33)
                }
            }
        }
       // .frame(width: 364, height: isCollapsed ? 94 : 230)
        //.frame(height: 90 + (1 - progress) * 140)
        .padding(20)
        .shadow(color: Color.hex("#4327F3").opacity(0.6), radius: 16, y: 8)
    }
}

