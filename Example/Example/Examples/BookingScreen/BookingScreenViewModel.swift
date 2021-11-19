//
//  BookingViewModel.swift
//  Example
//
//  Created by danil.kristalev on 19.11.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import Foundation

class BookingScreenViewModel: ObservableObject {
    @Published var placeName: String = "Capo Bay Hotel"
    @Published var stars: Double = 4.9
    @Published var address: String = "2, Iasonos Street, 5311 Pritaras, Cyprus"
    @Published var roomDesription: String = "2 beds • 2 bedroom • 1 kitchen • 1 bath"
    @Published var badges: [(String, String)] = [("wifi", "Wi-fi"),("tv", "TV"), ("creditcard", "Card"), ("fork.knife", "Breakfast"), ("car","Parking")]
    
    @Published var description: String = """
    The Capo Bay Hotel in Protaras, Cyprus is exceptionally located in the heart of Protaras. This beach hotel in Protaras features gardens with running waters and fish ponds lead down to the waterfront and the Blue Flag Fig Tree Bay.

    Capo Bay guest rooms are equipped with air conditioning, satellite TV and hot drink facilities. Free WiFi is available throughout. Several rooms face the Mediterranean Sea.

    Buffet breakfast is served every morning, and the hotel’s restaurant provides far-reaching sea views. Lunch and dinner are served at the Koi lounge bar, at the a la carte restaurant or the pool bar when the weather is warm.

    Ideal for relaxing holidays, the Capo Bay has a spa center which includes a sauna, hot tub, steam bath, hammam, Vichy shower, a fully equipped gym and a 14 m heated indoor lap pool. Recreation facilities include a modern fitness center and a scuba diving school.
    """
    
}
