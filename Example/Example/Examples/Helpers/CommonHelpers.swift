//
//  CommonHelpers.swift
//  Example
//
//  Created by danil.kristalev on 19.11.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI

struct CircleButtonStyle: ButtonStyle {

    var foreground = Color.black
    var background = Color.white

    var imageName: String

    func makeBody(configuration: Configuration) -> some View {
        Circle()
            .fill(background)
            .overlay(Image(systemName: imageName)
                        .foregroundColor(foreground)
                        .padding(12))
            .frame(width: 40, height: 40)
    }
}
