//
//  BookingScreen.swift
//  Example
//
//  Created by Danil Kristalev on 19.11.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderScrollView
import MapKit

struct BookingScreen: View {
    
    @ObservedObject private var viewModel = BookingScreenViewModel()
    @Environment(\.presentationMode) var presentationMode

    @State var snapTo: SnapHeaderState?

    var body: some View {
        ZStack {
            ScalingHeaderScrollView {
                Map(coordinateRegion: $viewModel.mapCenterRegion, annotationItems: viewModel.hotels) { place in
                    MapAnnotation(coordinate: place.coordinate) {
                        mapMarker(isSelected: place == viewModel.currentHotel, price: place.price)
                            .offset(y: -15)
                            .onTapGesture {
                                viewModel.select(hotel: place)
                            }
                    }
                }
            } content: {
                bookingContentView
            }
            .snapHeaderToState($snapTo)

            topButtons
            footer
        }
        .ignoresSafeArea()
    }
    
    private var topButtons: some View { 
        VStack {
            HStack(spacing: 16) {
                Button("") { self.presentationMode.wrappedValue.dismiss() }
                    .buttonStyle(CircleButtonStyle(imageName: "arrow.backward"))
                    .padding(.leading, 16)
                Spacer()
                Button("") {
                    print("Share")
                    snapTo = .collapsed
                }
                .buttonStyle(CircleButtonStyle(imageName: "arrowshape.turn.up.forward.fill"))

                Button("") {
                    print("Like")
                    snapTo = .expanded
                }
                .buttonStyle(CircleButtonStyle(imageName: "heart.fill", foreground: .appRed))
                .padding(.trailing, 16)
            }
            Spacer()
        }
        .padding(.top, 45)
        .ignoresSafeArea()
    }
    
    private var footer: some View {
        VStack {
            Spacer()
            ZStack {
                Rectangle()
                    .fill(.white)
                    .frame(height: 180)
                    .padding(.bottom, -100)
                HStack {
                    price
                    Spacer()
                    bookButton
                }
            }
        }
        .ignoresSafeArea()
        .padding(.bottom, 40)
    }
    
    private var price: some View {
        HStack {
            Text("$ \(viewModel.price)")
                .fontBold(color: .black, size: 24)
            Text("/night")
                .fontRegular(color: .black, size: 16)
        }
        .padding(.leading, 16)
    }
    
    private var bookButton: some View {
        Button("Book now", action: { print("book") })
            .buttonStyle(BookButtonStyle())
            .padding(.trailing, 16)
            .frame(width: 211, height: 60, alignment: .bottom)
    }
    
    private var bookingContentView: some View {
        VStack {
            contentHeader
            details
            Color.clear.frame(height: 100)
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
            .fontBold(color: .appDarkGray, size: 24)
    }
    
    private var stars: some View {
        HStack(alignment: .center , spacing: 8) {
            Image("Star")
                .offset(y: -3)
            Text(String(format: "%.1f", viewModel.stars))
                .fontBold(color: .appYellow, size: 18)
        }
    }
    
    private var address: some View {
        HStack(spacing: 6.5) {
            Image(systemName: "mappin")
                .foregroundColor(.appBookingBlue)
                .frame(width: 11, height: 14)
            Text(viewModel.address)
                .fontRegular(color: .appBookingBlue, size: 16)
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
                .fontBold(color: .appDarkGray, size: 18)
            Spacer()
        }
    }
    
    private var roomDesription: some View {
        HStack {
            Text(viewModel.roomDesription)
                .fontRegular(color: .appGray, size: 16)
            Spacer()
        }
    }
    
    private var badges: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.badges, id: \.self) { badge in
                    badgeView(image: badge.imageName, title: badge.label)
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
                        .fontRegular(color: .appGray, size: 12)
                }
                .padding(.top, 21)
            )
            .frame(width: 80, height: 80)
    }
    
    private var description: some View {
        Text(viewModel.description)
            .fontRegular(color: .appGray, size: 16)
            .padding(.top, 32)
    }
    
    private func mapMarker(isSelected: Bool = false, price: Int) -> some View {
        Text("$ \(price)")
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .fontBold(color: isSelected ? .white : .black, size: 14)
            .background(
                ZStack {
                    Triangle()
                        .fill(isSelected ? Color.appBookingBlue : .white)
                        .offset(y: 16)
                        .frame(width: 12, height: 8)
                    RoundedRectangle(cornerRadius: 30)
                        .fill(isSelected ? Color.appBookingBlue : .white)
                }
            )
    }
}

struct BookingScreen_Previews: PreviewProvider {
    static var previews: some View {
        BookingScreen()
    }
}
