//
//  ProfileScreen.swift
//  Example
//
//  Created by Danil Kristalev on 01.11.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderScrollView

struct ProfileScreen: View {

    @ObservedObject private var viewModel = ProfileScreenViewModel()
    @Environment(\.presentationMode) var presentationMode

    private let minHeight = 110.0
    private let maxHeight = 372.0

    var body: some View {
        ZStack {
            ScalingHeaderScrollView(minHeight: minHeight, maxHeight: maxHeight) { _, progress in
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    largeHeader(progress: progress)
                }
            } content: {
                profileDetailsView
            }
            .allowsHeaderGrowth()
            .headerAlignment(.bottom)

            topButtons
            hireButton
        }
        .ignoresSafeArea()
    }

    private var topButtons: some View {
        VStack {
            HStack {
                Button("", action: { self.presentationMode.wrappedValue.dismiss() })
                    .buttonStyle(CircleButtonStyle(imageName: "arrow.backward"))

                Spacer()

                Button("", action: { print("Info") })
                    .buttonStyle(CircleButtonStyle(imageName: "ellipsis"))
            }
            .padding(.horizontal, 17)
            .padding(.top, 50)

            Spacer()
        }
        .ignoresSafeArea()
    }

    private var hireButton: some View {
        VStack {
            Spacer()
            Button("Hire", action: { print("hire") })
                .buttonStyle(HireButtonStyle())
                .padding(.horizontal, 15)
                .frame(height: 60)
                .padding(.top, 10)
                .padding(.bottom, 50)
                .background {
                    VisualEffectView(effect: UIBlurEffect(style: .regular))
                        .ignoresSafeArea()
                }
        }
    }

    private var smallHeader: some View {
        HStack(spacing: 12.0) {
            Image(viewModel.avatarImage)
                .resizable()
                .frame(width: 40.0, height: 40.0)
                .clipShape(RoundedRectangle(cornerRadius: 6.0))

            Text(viewModel.userName)
                .fontRegular(color: .appDarkGray, size: 17)
        }
    }

    private func largeHeader(progress: CGFloat) -> some View {
        ZStack {
            Image(viewModel.avatarImage)
                .resizable()
                .scaledToFill()
                .frame(height: maxHeight)
                .opacity(1 - progress)

            VStack {
                Spacer()

                HStack(spacing: 4.0) {
                    Capsule()
                        .frame(width: 40.0, height: 3.0)
                        .foregroundColor(.white)

                    Capsule()
                        .frame(width: 40.0, height: 3.0)
                        .foregroundColor(.white.opacity(0.2))

                    Capsule()
                        .frame(width: 40.0, height: 3.0)
                        .foregroundColor(.white.opacity(0.2))
                }

                ZStack(alignment: .leading) {
                    VisualEffectView(effect: UIBlurEffect(style: .regular))
                        .mask(Rectangle().cornerRadius(40, corners: [.topLeft, .topRight]))
                        .offset(y: 10.0)
                        .frame(height: 80.0)

                    RoundedRectangle(cornerRadius: 40.0, style: .circular)
                        .foregroundColor(.clear)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.white.opacity(0.0), .white]), startPoint: .top, endPoint: .bottom)
                        )

                    Text(viewModel.userName)
                        .fontBold(color: .appDarkGray, size: 24)
                        .padding(.leading, 24.0)
                        .padding(.top, 10.0)
                        .opacity(1 - max(0, min(1, (progress - 0.75) * 4.0)))

                    smallHeader
                        .padding(.leading, 85.0)
                        .opacity(progress)
                        .opacity(max(0, min(1, (progress - 0.75) * 4.0)))
                }
                .frame(height: 80.0)
            }
        }
    }

    private var profileDetailsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(viewModel.profession)
                .fontRegular(color: .appGray, size: 16)

            Text(viewModel.address)
                .fontRegular(color: .appLightGray, size: 16)

            reviews

            skills

            Text(viewModel.description)
                .fontRegular(color: .appGray, size: 15)

            portfolio

            Color.clear.frame(height: 100)
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
    }

    private var reviews: some View {
        HStack(spacing: 8) {
            Image("Star")
                .offset(y: -3)
            Text(String(format: "%.1f", viewModel.grade))
                .fontBold(color: .appYellow, size: 18)
            Text("\(viewModel.reviewCount) reviews")
                .fontRegular(color: .appLightGray, size: 16)
        }
    }

    private var skills: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Skills")
                .fontBold(color: .appDarkGray, size: 18)
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

    private func skillView(for skill: String) -> some View {
        Text(skill)
            .padding(.vertical, 5)
            .padding(.horizontal, 14)
            .fontRegular(color: .appProfileBlue, size: 16)
            .lineLimit(1)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.appProfileBlue.opacity(0.08))
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.appProfileBlue))
            )
    }

    private var portfolio: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(minimum: 100)),
            GridItem(.flexible(minimum: 100)),
            GridItem(.flexible(minimum: 100))
        ]) {
            ForEach(viewModel.portfolio, id: \.self) { imageName in
                Image(imageName)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileScreen()
        }
    }
}
