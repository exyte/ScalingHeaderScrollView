//
//  CommonHelpers.swift
//  Example
//
//  Created by Danil Kristalev on 19.11.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI

struct CircleButtonStyle: ButtonStyle {

    var imageName: String
    var foreground = Color.black
    var background = Color.white
    var width: CGFloat = 40
    var height: CGFloat = 40

    func makeBody(configuration: Configuration) -> some View {
        Circle()
            .fill(background)
            .overlay(Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(foreground)
                        .padding(12))
            .frame(width: width, height: height)
    }
}

extension Color {
    
    static let appDarkGray = Color.hex("#0C0C0C")
    static let appGray = Color.hex("#0C0C0C").opacity(0.8)
    static let appLightGray = Color.hex("#0C0C0C").opacity(0.4)
    static let appYellow = Color.hex("#FFAC0C")
    
    //Booking
    static let appRed = Color.hex("#F62154")
    static let appBookingBlue = Color.hex("#1874E0")
    
    //Profile
    static let appProfileBlue = Color.hex("#374BFE")
}

extension View {

    func fontBold(color: Color = .black, size: CGFloat) -> some View {
        foregroundColor(color).font(.custom("Circe-Bold", size: size))
    }

    func fontRegular(color: Color = .black, size: CGFloat) -> some View {
        foregroundColor(color).font(.custom("Circe", size: size))
    }
}
