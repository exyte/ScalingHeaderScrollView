//
//  BookingScreenHelper.swift
//  Example
//
//  Created by danil.kristalev on 19.11.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI

struct BookButtonStyle: ButtonStyle {

    var foreground = Color.white

    func makeBody(configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.appBookingBlue)
            .overlay(configuration.label.foregroundColor(foreground))
    }
}
