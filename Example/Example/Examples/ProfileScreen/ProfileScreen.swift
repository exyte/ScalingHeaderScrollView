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
    @ObservedObject private var viewModel = ProfileScreenViewModel()

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            ScalingHeaderView { _ in
                Image(viewModel.avatarImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } content: {
                profilerContentView
            }

            infoButton
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }

    private var backButton: some View {
        Button("", action: {self.presentationMode.wrappedValue.dismiss() })
            .buttonStyle(CircleButtonStyle(imageName: "arrow.backward"))

    }

    private var infoButton: some View {
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
        .ignoresSafeArea()
    }

    private var profilerContentView: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    personalInfo
                    reviews
                    skills
                }
                .padding(.top, 40)
                .padding(.leading, 24)

                Spacer()
            }
        }
    }

    private var personalInfo: some View {
        VStack(alignment: .leading, spacing: 10) {
            userName
            VStack(alignment: .leading) {
                profession
                address
            }
        }
    }

    private var userName: some View {
        Text(viewModel.userName)
            .font(.custom("Circe-Bold", size: 24))
    }

    private var profession: some View {
        Text(viewModel.profession)
            .foregroundColor(.init(white: 0.2))
            .font(.custom("Circe-Regular", size: 16))
    }

    private var address: some View {
        Text(viewModel.address)
            .foregroundColor(.init(white: 0.6))
            .font(.custom("Circe-Regular", size: 16))
    }

    private var reviews: some View {
        HStack(alignment: .center , spacing: 8) {
            Image("Star")
                .offset(y: -3)
            grade
            reviewCount
        }
    }

    private var grade: some View {
        Text(String(format: "%.1f", viewModel.grade))
            .foregroundColor(Color(UIColor(hex: "#ffac0cff")!))
            .font(.custom("Circe-Bold", size: 18))
    }

    private var reviewCount: some View {
        Text("\(viewModel.reviewCount) reviews")
            .foregroundColor(.init(white: 0.6))
            .font(.custom("Circe-Regular", size: 16))
    }

    private var skills: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Skils")
                .font(.custom("Circe-Bold", size: 18))

            HStack {
                ForEach((0 ..< 3)) { col in
                    skillView(for: viewModel.skils[col])
                }
            }
            HStack {
                ForEach((0 ..< 3)) { col in
                    skillView(for: viewModel.skils[col + 3])
                }
            }



        }
    }

    func skillView(for skill: String) -> some View {
        let color = UIColor(hex: "#374BFEFF")!

        return Text(skill)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .padding(.leading, 14)
            .padding(.trailing, 14)
            .font(.custom("Circe", size: 16))
            .foregroundColor(Color(color))
            .lineLimit(1)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(color.withAlphaComponent(0.08)))
                    .overlay( RoundedRectangle(cornerRadius: 6).stroke(Color(color)))
            )
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
        Group {
            ProfileScreen()
        }
    }
}
