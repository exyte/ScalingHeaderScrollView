//
//  ProfileScreenViewModel.swift
//  Example
//
//  Created by Danil Kristalev on 01.11.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import Foundation
import Combine

class ProfileScreenViewModel: ObservableObject {
    @Published var avatarImage: String = "profileAvatar"
    @Published var userName: String = "Alisa Millford"
    @Published var profession: String = "UX/UI designer"
    @Published var address: String = "116 Black Fox Rd, Parker, PA, 16049"
    @Published var grade: Double = 4.8
    @Published var reviewCount: Int = 1708
    @Published var skils: [String] = ["UX research", "Wireframing", "UX writing", "Coding", "Analytical", "UI prototyping"]
}
