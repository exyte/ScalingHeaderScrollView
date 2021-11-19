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
    
    @ObservedObject private var viewModel = BookingScreenViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        ZStack {
            ScalingHeaderView { progress in
                ZStack {
                   
                }
            } content: {
                bookingContentView
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
                Button("", action: { print("Share") })
                    .buttonStyle(CircleButtonStyle(imageName: "arrowshape.turn.up.forward.fill"))
                Button("", action: { print("Like") })
                    .buttonStyle(CircleButtonStyle(foreground: Color.hex("#F62154"), imageName: "heart.fill"))
                    .padding(.trailing, 16)
            }
            Spacer()
        }
        .padding(.top, 45)
        .ignoresSafeArea()
    }
    
    private var bookingContentView: some View {
        VStack {
            contentHeader
            details
        }
        .padding(.top, 40)
        .padding(.horizontal, 24)
    }
    
    private var contentHeader: some View {
        VStack(spacing: 0) {
            HStack {
                placeName
                Spacer()
                stars
            }
            address
        }
        
    }
    
    private var placeName: some View {
        Text(viewModel.placeName)
            .foregroundColor(Color.hex("#0C0C0C"))
            .font(.custom("Circe-Bold", size: 24))
    }
    
    private var stars: some View {
        HStack(alignment: .center , spacing: 8) {
            Image("Star")
                .offset(y: -3)
            Text(String(format: "%.1f", viewModel.stars))
                .foregroundColor(Color.hex("#FFAC0C"))
                .font(.custom("Circe-Bold", size: 18))
        }
    }
    
    private var address: some View {
        HStack(spacing: 6.5) {
            Image(systemName:  "mappin")
                .foregroundColor(Color.hex("#1874E0"))
                .frame(width: 11, height: 14)
            Text(viewModel.address)
                .foregroundColor(Color.hex("#1874E0"))
                .font(.custom("Circe", size: 16))
            Spacer()

        }
    }
    
    private var details: some View {
        VStack(spacing: -2) {
            detailsHeader
            roomDesription
            badges
            description
        }
        .padding(.top, 30)
    }
    
    private var detailsHeader: some View {
        HStack {
            Text("Details")
                .foregroundColor(Color.hex("#0C0C0C"))
                .font(.custom("Circe-Bold", size: 18))
            Spacer()
        }
    }
    
    private var roomDesription: some View {
        HStack {
            Text(viewModel.roomDesription)
                .foregroundColor(Color.hex("#0C0C0C").opacity(0.8))
                .font(.custom("Circe", size: 16))
            Spacer()
            
        }
    }
    
    private var badges: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.badges.indices) { index in
                    let (imageName, title) = viewModel.badges[index]
                    badgeView(image: imageName, title: title)
                }
            }
        }
        .padding(.top, 20)
    }
    
    private func badgeView(image: String, title: String) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.black.opacity(0.04))
            .overlay(
                VStack {
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 21)
                    Text(title)
                        .foregroundColor(Color.hex("#0C0C0C").opacity(0.8))
                        .font(.custom("Circe", size: 12))
                }
                    .padding(.top, 21)
            )
            .frame(width: 80, height: 80)
    }
    
    private var description: some View {
        Text(viewModel.description)
            .foregroundColor(Color.hex("#0C0C0C").opacity(0.8))
            .font(.custom("Circe", size: 16))
            .padding(.top, 32)
    }
}

struct BookingScreen_Previews: PreviewProvider {
    static var previews: some View {
        BookingScreen()
    }
}
