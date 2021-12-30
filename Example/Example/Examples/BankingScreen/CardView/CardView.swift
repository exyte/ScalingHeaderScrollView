//
//  CardView.swift
//  Example
//
//  Created by Danil Kristalev on 30.12.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI

struct CardView: View {
    @State var isCollapsed = false
    
    var banance: String {
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
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(gradient:
                                    Gradient(colors: [Color.hex("#2B27F3"), Color.hex("#872AFD")]), startPoint: .topLeading, endPoint: .bottomTrailing))
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("BALANCE")
                            .foregroundColor(Color.white.opacity(0.7))
                            .font(.custom("Circe", size: 8))
                            .tracking(1.5)
                        
                        Text(banance)
                            .foregroundColor(Color.white)
                            .font(.custom("Circe-ExtraBold", size: 24))
                    }
                    
                    Spacer()
                    
                    if (!isCollapsed) {
                        Image("Visa")
                            .resizable()
                            .frame(width: 60, height: 18)
                    } else {
                        HStack(spacing: 12) {
                            Text("**** ")
                                .foregroundColor(Color.white)
                                .font(.system(size: 20,weight: .bold))
                            Text("0777")
                                .foregroundColor(Color.white)
                                .font(.custom("Circe-Bold", size: 20))
                        }
                        
                    }
                    
                }
                .padding(.horizontal, 32)
                .padding(.top, 24)
                .padding(.bottom, isCollapsed ? 24 : 0)
                
                
                
                if (!isCollapsed) {
                    Spacer()
                    
                    HStack(spacing: 39) {
                        Text("**** ")
                            .foregroundColor(Color.white)
                            .font(.system(size: 20,weight: .bold))
                        Text("**** ")
                            .foregroundColor(Color.white)
                            .font(.system(size: 20,weight: .bold))
                        Text("**** ")
                            .foregroundColor(Color.white)
                            .font(.system(size: 20,weight: .bold))
                        Text("0777")
                            .foregroundColor(Color.white)
                            .font(.custom("Circe-Bold", size: 20))
                        
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("CARD HOLDER")
                                .foregroundColor(Color.white.opacity(0.7))
                                .font(.custom("Circe", size: 8))
                                .tracking(1.5)
                            
                            Text("TOM HOLLAND")
                                .foregroundColor(Color.white)
                                .font(.custom("Circe", size: 15))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("EXPIRES")
                                .foregroundColor(Color.white.opacity(0.7))
                                .font(.custom("Circe", size: 8))
                                .tracking(1.5)
                            
                            Text("11/24")
                                .foregroundColor(Color.white)
                                .font(.custom("Circe-Bold", size: 15))
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 33)
                    
                }
            }
        }
        .frame(width: 364, height: isCollapsed ? 94 : 230)
        .shadow( color: Color.hex("#4327F3"), radius: 16)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(isCollapsed: false)
    }
}
