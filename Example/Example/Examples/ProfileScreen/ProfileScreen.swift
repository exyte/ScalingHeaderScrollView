//
//  ProfileScreen.swift
//  Example
//
//  Created by Danil Kristalev on 01.11.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderView

struct ProfileScreen: View {
    @ObservedObject private var profileViewModel = ProfileScreenViewModel()

    @Environment(\.presentationMode) var presentationMode

    var backButton: some View {
        Button("", action: {self.presentationMode.wrappedValue.dismiss() })
            .buttonStyle(CircleButtonStyle(imageName: "arrow.backward"))

    }

    var body: some View {
        ZStack {
            ScalingHeaderView { _ in
                Image(profileViewModel.avatarImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } content: {

            }

            VStack {
                HStack {
                    Spacer()
                    Button("", action: {})
                        .buttonStyle(CircleButtonStyle(imageName: "ellipsis"))
                        .padding(.trailing, 17)
                        .padding(.top, 50)
                }
                Spacer()
            }
            .border(Color.black)
            .ignoresSafeArea()



        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
}



private struct CircleButtonStyle: ButtonStyle {
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

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
