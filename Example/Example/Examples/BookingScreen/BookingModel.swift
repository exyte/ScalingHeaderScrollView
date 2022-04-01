//
//  BookingModel.swift
//  Example
//
//  Created by Danil Kristalev on 22.11.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit

struct Hotel: Identifiable, Equatable {
    
    let id = UUID()
    let name: String
    let stars: Double
    let address: String
    let roomDescription: String
    let badges: [Badge]
    let price: Int
    let coordinate: CLLocationCoordinate2D
    let description: String
    
    static func ==(lhs: Hotel, rhs: Hotel) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Badge: Identifiable, Hashable {
    
    let id = UUID()
    let label: String
    let imageName: String
    
    static func ==(lhs: Badge, rhs: Badge) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let wifi = Badge(label: "Wi-fi", imageName: "wifi")
    static let tv = Badge(label: "TV", imageName: "tv")
    static let card = Badge(label: "Card", imageName: "creditcard")
    static let breakfast = Badge(label: "Breakfast", imageName: "fork.knife")
    static let parking = Badge(label: "Parking", imageName: "car")
}

extension Hotel {
    
    static let capoBayHotel = Hotel (
        name: "Capo Bay Hotel",
        stars: 4.9,
        address: "2, Iasonos Street, 5311 Pritaras, Cyprus",
        roomDescription: "2 beds • 2 bedrooms • 1 kitchen • 1 bath",
        badges: [.wifi, .tv, .card, .breakfast, .parking],
        price: 560,
        coordinate: CLLocationCoordinate2D(latitude: 35.01336453367166, longitude: 34.05727061284338),
        description: """
        The Capo Bay Hotel in Protaras, Cyprus is exceptionally located in the heart of Protaras. This beach hotel in Protaras features gardens with running waters and fish ponds lead down to the waterfront and the Blue Flag Fig Tree Bay.

        Capo Bay guest rooms are equipped with air conditioning, satellite TV and hot drink facilities. Free WiFi is available throughout. Several rooms face the Mediterranean Sea.

        Buffet breakfast is served every morning, and the hotel’s restaurant provides far-reaching sea views. Lunch and dinner are served at the Koi lounge bar, at the a la carte restaurant or the pool bar when the weather is warm.

        Ideal for relaxing holidays, the Capo Bay has a spa center which includes a sauna, hot tub, steam bath, hammam, Vichy shower, a fully equipped gym and a 14 m heated indoor lap pool. Recreation facilities include a modern fitness center and a scuba diving school.
        """)
    
    static let figTreeBayVilla = Hotel(
        name: "Fig Tree Bay Villa",
        stars: 5.0,
        address: "Leoforos Protara - Kavo Greco 435 A, 5296 Protaras, Cyprus",
        roomDescription: "9 beds • 5 bedrooms • 1 kitchen • 4 bathrooms",
        //TODO: Add badges: pool, bbq, seaview
        badges: [.wifi, .tv, .card, .parking],
        price: 900,
        coordinate: CLLocationCoordinate2D(latitude: 35.01273793654151, longitude: 34.05682165773294),
        description: """
        Boasting air-conditioned accommodations with a private pool, Fig Tree Bay Residences 5 is set in Protaras. Featuring pool views, a swimming pool and a garden, this villa also has free WiFi.

        The villa features 5 bedrooms, a flat-screen TV with cable channels, an equipped kitchen with a dishwasher and a microwave, a washing machine, and 4 bathrooms with a shower. Pool heating is provided upon charge.

        The villa offers a barbecue and a terrace.

        National Forest Park Kavo Gkreko is 3.7 mi from Fig Tree Bay Residences 5, while Sunrise Beach is 1.2 mi away.
        This is our guests' favorite part of Protaras, according to independent reviews.

        We speak your language!
        """)
    
    static let protarasPlazaHotel = Hotel(
        name: "Protaras Plaza Hotel",
        stars: 4.3,
        address: "69, Protaras Avenue , 5296 Protaras, Cyprus",
        roomDescription: "1 bed • 1 bedrooms • 1 bath",
        //TODO: add badges
        badges: [.wifi, .tv, .card, .parking],
        price: 350,
        coordinate:  CLLocationCoordinate2D(latitude: 35.01134901020586, longitude: 34.05726149727718),
        description: """
        Located just 100 m of Fig Tree Bay Beach, Protaras Plaza Hotel in Protaras has a number of amenities including an outdoor swimming pool, a fitness center and a garden. With a terrace, the property also features a shared lounge, as well as a bar. The restaurant serves Mediterranean cuisine. Free WiFi is available.

        At the hotel, the rooms include a desk. Rooms are complete with a private bathroom, while certain units at Protaras Plaza Hotel also provide guests with a seating area. All guest rooms will provide guests with a wardrobe and a kettle.

        Facilities include an Asian restaurant and sushi bar, as well as a revolving rooftop bar, a pool bar and a lobby bar

        The accommodations offers 3-star accommodations with an indoor pool.

        Speaking Greek, English and Swedish, staff will be happy to provide guests with practical guidance on the area at the 24-hour front desk.

        Konnos Bay is 3.1 mi away, while Ayia Napa is at 8.7 mi. Larnaca International Airport is 40 mi away.
        This is our guests' favorite part of Protaras, according to independent reviews.
        """)
}

struct MapService {
    
    let hotels: [Hotel] = [.capoBayHotel, .figTreeBayVilla, .protarasPlazaHotel]
    
    let mapCenterRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:  35.01266423456241, longitude: 34.057450219436646), latitudinalMeters: 400, longitudinalMeters: 400)
}
