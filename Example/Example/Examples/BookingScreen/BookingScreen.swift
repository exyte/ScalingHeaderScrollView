//
//  BookingScreen.swift
//  Example
//
//  Created by danil.kristalev on 19.11.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderView

struct BookingScreen: View {
    
    @ObservedObject private var viewModel = ProfileScreenViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        ZStack {
            ScalingHeaderView { progress in
                ZStack {
                   
                }
            } content: {
            }
            .allowsHeaderCollapse(false)
            .allowsHeaderScale(true)
            
            topButtons
        }
        .ignoresSafeArea()
    }
    
    private var topButtons: some View { 
        VStack {
            HStack(spacing: 16) {
                Button("", action: { self.presentationMode.wrappedValue.dismiss() })
                    .buttonStyle(CircleButtonStyle(imageName: "arrow.backward"))
                    .padding(.leading, 16)
                Spacer()
                Button("", action: { print("Info") })
                    .buttonStyle(CircleButtonStyle(imageName: "arrowshape.turn.up.forward.fill"))
                Button("", action: { print("Info") })
                    .buttonStyle(CircleButtonStyle(foreground: Color.hex("#F62154"), imageName: "heart.fill"))
                    .padding(.trailing, 16)
            }
            Spacer()
        }
        .padding(.top, 45)
        .ignoresSafeArea()
    }
}

struct BookingScreen_Previews: PreviewProvider {
    static var previews: some View {
        BookingScreen()
    }
}
